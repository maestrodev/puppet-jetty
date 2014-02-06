class jetty(
  $version,
  $home        = '/opt',
  $manage_user = true,
  $user        = 'jetty',
  $group       = 'jetty',
) {

  include wget

  if $manage_user {

    ensure_resource('user', $user, {
      managehome => true,
      system     => true,
      gid        => $group,
      before     => Exec['jetty_untar'],
    })

    ensure_resource('group', $group, { 
      ensure => present
    })
  }

  wget::fetch { "jetty_download":
    source      => "http://repo1.maven.org/maven2/org/eclipse/jetty/jetty-distribution/${version}/jetty-distribution-${version}.tar.gz",
    destination => "/usr/local/src/jetty-distribution-${version}.tar.gz",
  } ->
  exec { "jetty_untar":
    command => "tar xf /usr/local/src/jetty-distribution-${version}.tar.gz && chown -R ${user}:${group} ${home}/jetty-distribution-${version}",
    cwd     => $home,
    creates => "${home}/jetty-distribution-${version}",
    path    => ["/bin",],
    notify  => Service["jetty"]
  } ->
  
  file { "${home}/jetty":
    ensure => "${home}/jetty-distribution-${version}",
  } ->

  file { "/var/log/jetty":
    ensure => "${home}/jetty/logs",
  } ->

  file { "/etc/default/jetty":
    content => template('jetty/default'),
  } ->

  file { "/etc/init.d/jetty":
    ensure => "${home}/jetty-distribution-${version}/bin/jetty.sh",
  } ~>

  service { "jetty":
    enable     => true,
    ensure     => running,
    hasstatus  => false,
    hasrestart => true,
  }

}
