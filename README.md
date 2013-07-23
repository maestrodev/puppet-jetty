# Puppet-Jetty

A module to install Jetty and configure the service

## Usage

    $jetty_home = "/opt/" # this will create a /opt/jetty-$jetty_version folder and a /opt/jetty linking to it
    $jetty_version = "9.0.4.v20130625"
    include jetty

## License

    Copyright 2012-2013 MaestroDev Inc.

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at
	
	  http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
