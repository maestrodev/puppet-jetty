class jetty (
  $version,
  $home        = "/opt",
  $manage_user = false,
  $user        = "jetty",
  $group       = "jetty",
) {

  include wget

  if $manage_user {
    user { "$user":
      ensure => present,
      managehome => true,
      system => true;
    }

    group { "$group":
      ensure => present;
    }
  }

  wget::fetch { "jetty_download":
    source      => "http://repo1.maven.org/maven2/org/eclipse/jetty/jetty-distribution/${version}/jetty-distribution-${version}.tar.gz",
    destination => "/usr/local/src/jetty-distribution-${version}.tar.gz",
  } ->

  exec { "jetty_untar":
    command => "tar xf /usr/local/src/jetty-distribution-${version}.tar.gz",
    cwd     => $home,
    creates => "${home}/jetty-distribution-${version}",
    path    => ["/bin",],
    require => [User[$user], Group[$group]]; 
  } ->

  file { "${home}/jetty-distribution-${version}":
    ensure  => directory,
    recurse => true,
    backup  => false,
    owner   => $user,
    group   => $group;
  } ->
  
  file { "${home}/jetty":
    ensure  => "${home}/jetty-distribution-${version}";
  } ->

  file { "/var/log/jetty":
    ensure  => "${home}/jetty/logs";
  } ->

  file { "/etc/default/jetty":
    content => template('jetty/default');
  } ->

  file { "/etc/init.d/jetty":
    ensure  => "${home}/jetty-distribution-${version}/bin/jetty.sh";
  } ~>

  service { "jetty":
    enable     => true,
    ensure     => running,
    hasstatus  => false,
    hasrestart => true;
  }
}
