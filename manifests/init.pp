class jetty {
  include wget
  wget::fetch { "jetty_download":
    source => "http://archive.eclipse.org/jetty/$jetty_version/dist/jetty-distribution-$jetty_version.tar.gz",
    destination => "/usr/local/src/jetty-distribution-$jetty_version.tar.gz",
  } ->
  #exec { "jetty_download":
  #  command => "wget http://download.eclipse.org/jetty/$jetty_version/dist/jetty-distribution-$jetty_version.tar.gz",
  #  cwd     => "/usr/local/src",
  #  creates => "/usr/local/src/jetty-distribution-$jetty_version.tar.gz",
  #  path    => ["/usr/bin", "/usr/sbin"],
  #  require => [Group["activemq"],Package["java-1.6.0-openjdk-devel"]],
  #}
  

  exec { "jetty_untar":
    command => "tar xf /usr/local/src/jetty-distribution-$jetty_version.tar.gz && chown -R $jetty_user:$jetty_group $jetty_home/jetty-distribution-$jetty_version",
    cwd     => "$jetty_home",
    creates => "$jetty_home/jetty-distribution-$jetty_version",
    path    => ["/bin",],
    notify => Service["jetty"]
  }
  
  file { "$jetty_home/jetty":
    ensure  => "$jetty_home/jetty-distribution-$jetty_version",
    require => Exec["jetty_untar"],
  }

  file { "/var/log/jetty":
    ensure  => "$jetty_home/jetty/logs",
    require => File["$jetty_home/jetty"],
  }
  
  file { "/etc/init.d/jetty":
    ensure => "$jetty_home/jetty-distribution-$jetty_version/bin/jetty.sh"
  }

  service {"jetty":
    enable => true,
    ensure => running,
    hasstatus => false,
    hasrestart => true,
    require => [ File['/etc/init.d/jetty'], File['/var/log/jetty'] ]
  }
  
}
