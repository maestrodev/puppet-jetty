In the site.pp manifest:

```ruby
# Jetty

$jetty_home = "/opt/" # this will create a /opt/jetty-$jetty_version folder and a /opt/jetty linking to it
$jetty_version = "9.0.4.v20130625"
include jetty
```
