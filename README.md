
<!--#echo json="package.json" key="name" underline="=" -->
npm-guess-supporting-information-for-issue
==========================================
<!--/#echo -->

<!--#echo json="package.json" key="description" -->
Answer the &quot;supporting information&quot; questionnaire for new npm bug
reports.
<!--/#echo -->


Setup
-----

On install of the package, npm should have set up the package name
as a command that invokes `siq.sh`.
If it doesn't work or you like a custom command, set up your preferred
method of invoking `siq.sh` yourself.

If your config file isn't created yet or lacks some settings,
instead of answering the questionnaire, it will tell you
where your config should be and which variables are missing.


Usage
-----

<!--#include file="tmp.howto.txt" code="bash" -->
<!--#verbatim lncnt="19" -->
```bash
$ npm-guess-supporting-information-for-issue
 - `npm -v` prints: 5.5.1
 - `node -v` prints: v6.12.0
 - `npm config get registry` prints: http://registry.npmjs.org/
 - Windows, OS X/macOS, or Linux?: GNU/Linux (Ubuntu 14.04.5 LTS trusty)
 - Network issues:
   - Geographic location where npm was run: .de
   - [x] I use a proxy to connect to the npm registry.
   - [x] I use a proxy to connect to the web.
   - [x] I use a proxy when downloading Git repos.
   - [ ] I access the npm registry via a VPN
   - [ ] I don't use a proxy, but have limited or unreliable internet access.
 - Container:
   - [ ] I develop using Vagrant on Windows.
   - [ ] I develop using Vagrant on OS X or Linux.
   - [ ] I develop / deploy using Docker.
   - [ ] I deploy to a PaaS (Triton, Heroku).
```
<!--/include-->



<!--#toc stop="scan" -->


Known issues
------------

* Tested on Ubuntu only. Might not work no non-linux OSs.




&nbsp;


License
-------
<!--#echo json="package.json" key=".license" -->
ISC
<!--/#echo -->
