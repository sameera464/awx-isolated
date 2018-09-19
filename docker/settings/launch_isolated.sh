awx-manage register_instance --hostname=isolated
awx-manage register_queue --queuename='thepentagon' --hostnames=isolated --controller=tower

/usr/bin/launch_awx_task.sh