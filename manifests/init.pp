class jetty {
  
  exec { "jetty_download":
    command => "wget http://download.eclipse.org/jetty/$jetty_version/dist/jetty-distribution-$jetty_version.tar.gz",
    cwd     => "/usr/local/src",
    creates => "/usr/local/src/jetty-distribution-$jetty_version.tar.gz",
    path    => ["/usr/bin", "/usr/sbin"],
    require => [Group["activemq"],Package["java-1.6.0-openjdk-devel"]],
  }
  
  exec { "jetty_untar":
    command => "tar xf /usr/local/src/jetty-distribution-$jetty_version.tar.gz && chown -R activemq:activemq /opt/jetty-distribution-$jetty_version",
    cwd     => "/opt",
    creates => "/opt/jetty-distribution-$jetty_version",
    path    => ["/bin",],
    require => Exec["jetty_download"],
#also need to chown activemq:activemq this dir
  }
  
  file { "/opt/jetty":
    ensure  => "/opt/jetty-distribution-$jetty_version",
    require => Exec["jetty_untar"],
  }

  file { "/var/log/jetty":
    ensure  => "/opt/jetty/logs",
    require => File["/opt/jetty"],
  }
  
  file { "/etc/init.d/jetty":
    ensure => "/opt/jetty-distribution-$jetty_version/bin/jetty.sh"
  }

  service {"jetty":
    ensure => running,
    hasrestart => true,
    require    => [File["/etc/init.d/jetty"],Exec["jetty_untar"],Exec["jetty_download"],File["/opt/jetty"],File["/var/log/jetty"]],
  }
  
}
