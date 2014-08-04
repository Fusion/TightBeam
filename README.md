TightBeam
=========

![TightBeam logo](doc/logo.png)

TB is like Ansible, with two differences: nowhere near as ambitious; nowhere near as verbose.

With TightBeam, everything is straightforward. No agent required; an off the shelf remote server should be manageable.

# Q&A

Q: What does TB do?

It monitors your servers. It comes with a few probes (memory, disk space, process...) and you can create your own easily. It can also notify you when these probes detect something wrong. Again, you can add your own notifiers.

Q: How does this scale?

It scales any way you want to make it scale. At this point, scalability is not a goal.

Q: But, what size network is it for?

Currently, I would say a few dozen servers; and it is nowhere near providing real time polling.

Q: Could it be made faster?

Definitely. I wrote TB to be as straightforward and dumb as possible. *Everything* can be improved.

Q: What technologies are you using?

I wanted something requiring approximately zero setup. Therefore, Bash and SSH are being used. You need Bash version >= 4 and SSH keys to automate connections.

Q: Are you going to create a governance body for this project? Will you offer commercial support?

What? No! This is a Sunday project that works well to monitor my servers so I pushed it to Github in case others find it useful. What are you even going on about?

# Help

## Adding a new server to TB's server database?

Add a file to the Servers/ folder. Typical content:

    #!/usr/bin/env bash

    declare -A mylocalhost=([name]="My local host" [server]="127.0.0.1" [description]="Example web and mail server")

    tb_update_server mylocalhost

## Monitoring this new server?

In your main script, make simple calls to your Probes. For instance:

    # Available memory needs to be >= 10%
    check_memory ${mylocalhost[name]} ${mylocalhost[server]} 10
    # bind ('named') process must be running
    check_process ${mylocalhost[name]} ${mylocalhost[server]} named

## Creating a new probe

    check_health() {
        # run your executors here -- see how it is done in existing probes
    }
    
    tb_update_probe check_health

## Creating a new executor

    #!/usr/bin/env bash
    
    ex_remotely() {
        # talk to your server here -- see how it is done in existing executors
    }
    
    # register this executor to be invoked when a 'cli' executor is required
    tb_update_executor ex_remotely cli

## Creating a new notifier

    #!/usr/bin/env bash
    
    alert_notifymysmartwatch() {
        # obviously, your code goes here: $1 represents your alert message.
    }
    
    # register this notifier to be invoked when an alert should be sent to a mobile device
    tb_update_notifier alert_notifymysmartwatch mobile

If you still have questions left, just ask.
