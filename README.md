In the site.pp manifest:

```ruby
# Jetty

$jetty_home = "/opt/" # this will create a /opt/jetty-$jetty_version folder and a /opt/jetty linking to it
$jetty_version = "7.4.2.v20110526"
include jetty
```
