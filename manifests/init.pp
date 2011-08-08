class jetty {
  
  exec { "jetty_download":
    command => "wget http://download.eclipse.org/jetty/$jetty_version/dist/jetty-distribution-$jetty_version.tar.gz",
    cwd     => "/usr/local/src",
    creates => "/usr/local/src/jetty-distribution-$jetty_version.tar.gz",
    path    => ["/usr/bin", "/usr/sbin"],
    require => [Group["activemq"],Package["java-1.6.0-openjdk-devel"]],
  }
  
  exec { "jetty_untar":
    command => "tar xf /usr/local/src/jetty-distribution-$jetty_version.tar.gz && chown -R $jetty_user:$jetty_group $jetty_home/jetty-distribution-$jetty_version",
    cwd     => "$jetty_home",
    creates => "$jetty_home/jetty-distribution-$jetty_version",
    path    => ["/bin",],
    require => Exec["jetty_download"],
#also need to chown activemq:activemq this dir
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
    ensure => running,
    hasrestart => true,
    require    => [File["/etc/init.d/jetty"],Exec["jetty_untar"],Exec["jetty_download"],File["$jetty_home/jetty"],File["/var/log/jetty"]],
  }
  
}
