FROM centos:7
RUN curl -o go1.13.linux-amd64.tar.gz https://dl.google.com/go/go1.13.linux-amd64.tar.gz
RUN  tar -C /usr/local -xzf go1.13.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin
RUN mkdir /tmp/an sible
WORKDIR /tmp/ansible
RUN curl -o ansible.tar.gz http://artifacts.si.mythic-ai.com/archive/ansible.develop.tar.gz
RUN tar xzvf ansible.tar.gz
RUN mkdir -vp /etc/slurm; cp -v /tmp/ansible/playbooks/roles/slurm_base/files/slurm.conf /etc/slurm/
RUN mkdir /tmp/rpms
WORKDIR /tmp/rpms
RUN curl -o slurm-20.02.5-1.el7.x86_64.rpm http://artifacts.si.mythic-ai.com/mythic-rpms/slurm-20.02.5-1.el7.x86_64.rpm
RUN curl -o slurm-contribs-20.02.5-1.el7.x86_64.rpm http://artifacts.si.mythic-ai.com/mythic-rpms/slurm-contribs-20.02.5-1.el7.x86_64.rpm
RUN curl -o slurm-devel-20.02.5-1.el7.x86_64.rpm http://artifacts.si.mythic-ai.com/mythic-rpms/slurm-devel-20.02.5-1.el7.x86_64.rpm
RUN curl -o slurm-example-configs-20.02.5-1.el7.x86_64.rpm http://artifacts.si.mythic-ai.com/mythic-rpms/slurm-example-configs-20.02.5-1.el7.x86_64.rpm
RUN curl -o slurm-libpmi-20.02.5-1.el7.x86_64.rpm http://artifacts.si.mythic-ai.com/mythic-rpms/slurm-libpmi-20.02.5-1.el7.x86_64.rpm
RUN curl -o slurm-openlava-20.02.5-1.el7.x86_64.rpm http://artifacts.si.mythic-ai.com/mythic-rpms/slurm-openlava-20.02.5-1.el7.x86_64.rpm
RUN curl -o slurm-pam_slurm-20.02.5-1.el7.x86_64.rpm http://artifacts.si.mythic-ai.com/mythic-rpms/slurm-pam_slurm-20.02.5-1.el7.x86_64.rpm
RUN curl -o slurm-perlapi-20.02.5-1.el7.x86_64.rpm http://artifacts.si.mythic-ai.com/mythic-rpms/slurm-perlapi-20.02.5-1.el7.x86_64.rpm
RUN curl -o slurm-slurmctld-20.02.5-1.el7.x86_64.rpm http://artifacts.si.mythic-ai.com/mythic-rpms/slurm-slurmctld-20.02.5-1.el7.x86_64.rpm
RUN curl -o slurm-slurmd-20.02.5-1.el7.x86_64.rpm http://artifacts.si.mythic-ai.com/mythic-rpms/slurm-slurmd-20.02.5-1.el7.x86_64.rpm
RUN curl -o slurm-slurmdbd-20.02.5-1.el7.x86_64.rpm http://artifacts.si.mythic-ai.com/mythic-rpms/slurm-slurmdbd-20.02.5-1.el7.x86_64.rpm
RUN curl -o slurm-torque-20.02.5-1.el7.x86_64.rpm http://artifacts.si.mythic-ai.com/mythic-rpms/slurm-torque-20.02.5-1.el7.x86_64.rpm
RUN yum install -y epel-release rpm-build gcc openssl openssl-devel pam-devel numactl numactl-devel lua readline-devel ncurses-devel gtk2-devel libibumad perl-ExtUtils-MakeMaker hwloc perl-Date-Simple 
RUN yum install -y munge munge-devel
ENV VER=20.02.5
RUN bash -c "yum install -y slurm-$VER*rpm"
RUN bash -c "yum install -y slurm-devel-$VER*rpm slurm-munge-$VER*rpm slurm-perlapi-$VER*rpm slurm-plugins-$VER*rpm slurm-torque-$VER*rpm"
RUN useradd slurm
RUN yum install -y sudo
COPY . /app
WORKDIR /app
RUN bash -c 'go build -o bin/prometheus-slurm-exporter {main,accounts,cpus,gpus,partitions,node,nodes,queue,scheduler,sshare,users}.go'
CMD ["bash", "/app/entrypoint.sh"]
