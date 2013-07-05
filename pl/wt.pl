#!/usr/bin/env perl
#---------------------#
#  PROGRAM:  wt.pl    #
#---------------------#

use strict;
use warnings;
use wt;
use Getopt::Long::Descriptive;
use Pod::Usage;
use FindBin '$Bin';
use 5.010;
use File::Basename;
use Data::Dumper;

use Log::Log4perl qw(:easy);
use YAML qw(LoadFile);

use LWP::UserAgent;
use MIME::Base64 qw(encode_base64);

our $VERSION = '0.102080';

my @args = @ARGV;
my $debug = 0; 

my $c = 0;
my $wtp = "$Bin/..";

sub vim;
sub ptlnd;
sub poddoc;
sub ssh;
sub proc;
sub see;
sub vundle;
sub hgserve;
sub upg;
sub cpanm;
sub test;

sub printArgs;
sub hasArgs;
sub sysexec;
sub load_cfg;

load_cfg;
$debug = $$c{debug};

#TODO_ITEM 
#
#  add 7z param for 7z some prj
#
#  prj list: hello wt
#  
#  use cmd : 7z a hello.7z hello-7z/

my ($opt               , $usage) = describe_options (
    'wt %o <some-arg>' ,
    [ 'help|h'     , " print usage message and exit " ] ,
    [ 'doc'        , " print poddoc                 " ] ,
    [ 'ssh|s=s'    , " ssh config name              " ] ,
    [ 'proc|p=s'   , " proc name for manage         " ] ,
    [ 'see|se=s'   , " log file name for tail       " ] ,
    [ 'cpanm|c=s'  , " install cpanm                " ] ,
    [ 'vundle'     , " check out vundle             " ] ,
    [ 'hgserve|hg' , " hgserve                      " ] ,
    [ 'upg|u=s'    , " upg manage                   " ] ,
    [ 'debug|d'    , " debug mode(no sysexec)       " ] ,
    [ 'test|t'     , " run test                     " ] ,
);
print($usage->text), exit if $opt->help;

$debug = 1 if $opt->debug;

printArgs if $debug; 

if      ( ! hasArgs 0   ) { vim;
} elsif ( $opt->doc     ) { poddoc;
} elsif ( $opt->ssh     ) { ssh;
} elsif ( $opt->proc    ) { proc;
} elsif ( $opt->see     ) { see;
} elsif ( $opt->cpanm   ) { cpanm;
} elsif ( $opt->vundle  ) { vundle;
} elsif ( $opt->hgserve ) { hgserve;
} elsif ( $opt->upg     ) { upg;
} elsif ( $opt->test    ) { test;
} elsif ( hasArgs 0     ) {
    vim $args[0];
}
exit;

#&uniq            (              ) if ( $opt->uniq        ) ;
#&minus           (              ) if ( $opt->minus       ) ;
#&smtp            (              ) if ( $opt->smtp        ) ;
#&vimopen         ( $0           ) if ( $opt->open        ) ;
#&enva            ( $args[1]     ) if ( $opt->enva        ) ;
#&do7z            (              ) if ( $opt->do7z        ) ;
#&explorer        (              ) if ( $opt->explorer    ) ;
#&mysql_server    (              ) if ( $opt->mysqlserver ) ;
#&h2_server       (              ) if ( $opt->h2server    ) ;
#&resin_server    (              ) if ( $opt->rsnserver   ) ;
#&mvn             (              ) if ( $opt->mvn         ) ;
#&mvn_start_jetty (              ) if ( $opt->rmvn        ) ;
#&mvn_create      (              ) if ( $opt->cmvn        ) ;
#&mvn_install     (              ) if ( $opt->imvn        ) ;
#&mvn_test_single (              ) if ( $opt->tmvn        ) ;
#catalyst_server  (              ) if ( $opt->caserver    ) ;
#&catalyst_create (              ) if ( $opt->catcreate   ) ;

sub wt_home {
    my $home = $ENV{HOME}?"$ENV{HOME}/.wt":'';
    my $cmd = 'mkdir';
    if($^O ~~ 'MSWin32') {
        $home = $ENV{USERPROFILE}.'\.wt';
        $cmd = 'md';
    }
    if(! -e $home){
        sysexec "$cmd \"$home\"";
    }
    $home;
}

sub load_cfg {
    my $wt_home = &wt_home();
    debug $wt_home;
    my $_conf = "$wt_home/conf";
    if (-e $_conf){
        $c= LoadFile( $_conf );
        debug "use conf: $_conf";
    }
    elsif(-e "$Bin/conf"){
        $c= LoadFile( "$Bin/conf" );
        debug 'use conf: bin/conf'
    }
    else {
        die("conf files not found.");
    }
}

sub poddoc {
    use Pod::Perldoc ();
    Pod::Perldoc->run();
}

sub vim {

    $ENV{'WTPATH'} = $wtp;
    $ENV{'MYSYS'} = $^O;
    $ENV{'RV_VIMRT'} = "$wtp/$$c{vim}{rtpath}";
    $ENV{'VUNDLE'} = "$$c{vim}{vundle}";
    my $wt_home = &wt_home();

    my $cmd = 'mkdir';
    if($^O ~~ 'MSWin32') {
        $cmd = 'md';
    }

    system("$cmd -p ~/.vim/tmp") if ! -e "~/.vim/tmp";

    my @filelist = @{$$c{vim}{openlist}};

    my ( $file_name ) = @_;
    $file_name = join (' -p ', @filelist) if ! $file_name;

    my $rc = "$wtp/$$c{vim}{rc}";
    my $_rc = "$wt_home/$$c{vim}{rc}";
    $rc = $_rc if -e $_rc;

    $cmd = "$$c{vim}{home}/$$c{vim}{bin} -u \"$rc\" -p ";
    $cmd.=$file_name if (defined $file_name);

    sysexec $cmd;
}

sub vimopen {
    my $file;

    given( $args[1] ) {
        when ( /^conf/ )  { $file = qq|/pl/conf|; break;}
        when ( /^rvrc/  ) { $file = qq|/vim/rvrc.vim|; break;}
        when ( /^vimrc/ ) { $file = qq|/vim/vimrc|; break;}
        default           { $file = qq|/pl/rv.pl|; }
    }

    vim ( $wtp.$file ) if ( defined $file );
}

sub see {
    if($args[1]) {
        my $seefile = $$c{see}{$args[1]};
        if($seefile){
            if( -e $seefile ){
                my $see_cmd = "tail -f";
                $see_cmd = $args[2] if($args[2]);

                my $cmd = "$see_cmd $seefile";

                debug "see_cmd:  $cmd";
                system $cmd;
            }
            else{
                error "seefile [$seefile] not found";
            }
        }
        else{
            error "no key [$args[1]] configed";
        }
    }
    else{
        error "no param seefile";
    }
}

sub cpanm {
    my $cmd = 'curl -k -L http://cpanmin.us | perl - -n -S --mirror http://mirrors.163.com/cpan App::cpanminus';

    $_ = `which cpanm`;
    s/[\r\n]//;
    my $cpanm = $_;

    $cpanm = '/usr/local/bin/cpanm' if ! $cpanm;

    sysexec $cmd if ! -e $cpanm;
    info $cmd if $opt->debug && $cpanm ;

    my $_ = $opt->{cpanm};
    s/\//::/g;
    $cmd = "$cpanm -n -S --mirror http://mirrors.163.com/cpan $_";

    sysexec $cmd;
}

sub enva {
    my ( $s ) = @_;
    print eval $s if(defined $s);
}

sub do7z {

    my $file;
    given( $args[1] ) {
        when ( /^conf/ )  { $file = qq|/pl/conf|; break;}
        when ( /^rvrc/  ) { $file = qq|/vim/rvrc.vim|; break;}
        when ( /^vimrc/ ) { $file = qq|/vim/vimrc|; break;}
        default           { $file = qq|/wt|; }
    }

    my $cmd = "7z a $wtp/..$file.7z $wtp";
    ptlnd($cmd);

    system $cmd;
}

sub explorer {
    my $opendir = ".";
    $opendir = $args[1] if ( $args[1] ) ;
    my $cmd = qq/$$c{file_explorer} $opendir/;

    system $cmd;
}

sub msys {
    my $opendir = ".";
    $opendir = $args[1] if ( $args[1] ) ;
    my $cmd = qq/$$c{file_explorer} $opendir/;

    $cmd = q|g:\msys\1.0\bin\rxvt.exe  -backspacekey  -sl 2500 -fg Green -bg Black -sr -fn Courier-12 -geometry 80x30 -e /bin/sh --login -i|;

    ptlnd $cmd;

    system $cmd;
}

#TODO 
sub catalyst_create {
    push @INC,$$c{catalyst}{extlib};

    my $cmd= "perl  $$c{catalyst}{catalyst} ";
    $cmd = $cmd.$args[1] if($args[1]) ;
    print $cmd;

    sysexec $cmd;
}

sub vundle {
    #FIXME 
    if(! -e "$ENV{'HOME'}/.vim/bundle/vundle" ){
        ptln "vundle not exists";
        sysexec "git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle";
    }
    #sysexec( "cp $Bin/../vim/vimrc_vundle ~/.vimrc" );
    #sysexec "vim +BundleInstall +qall";
}

sub hgserve {

    my $wt_home = &wt_home();
    my $webconf_file = "$wt_home/web-conf";
    my $webconf = <<EOF;
[paths]
/ = /upg/**

[auth]
foo.prefix = * 
foo.username = root
#foo.password = barfoo
foo.schemes = http https

[web]
allow_push=*
push_ssl = false
encoding = iso-8859-1
style = gitweb
EOF
    my $pidfile = '/tmp/hg.pid';
    if ( ! -e $webconf_file ) {
        open (F, "> $webconf_file") or error "$! $webconf_file";
        print F $webconf;
        close(F);
    }
    my $pid = get_pid('bin/hg', 'serve');
    if($pid > 0){
        ptln "hg running with [ $pid ]";
    }
    else{
        my $cmd = "hg serve -p 8001 -d -a localhost --web-conf=$webconf_file --pid-file $pidfile";
        ptln $cmd;
        sysexec $cmd;
    }
}

sub bbkrepos {
    my ( $user, $pass) = @_;
    my $ua = LWP::UserAgent->new;
    my $encode_login = encode_base64($user. ":" . $pass);
    my @headers = ('User-Agent' => 'Mozilla/5.0', 
        Authorization => "Basic $encode_login", 
    ); 
    $ua->default_header(@headers);

    my $response = $ua->get('https://api.bitbucket.org/1.0/user/repositories');

    if ($response->is_success) {
        use JSON::Tiny;
        my $json  = JSON::Tiny->new;
        my $hash  = $json->decode($response->decoded_content);
        @{$hash};
    }
    else{
        die $response->status_line;
    }
}

sub hgexec {
    my ($cmd, $pullall) = @_;

    my $user = $$c{bitbucket}{user};
    my $pass = $$c{bitbucket}{pass};

    if($pullall){
        my @repos = &bbkrepos($user, $pass);

        foreach my $repo(@repos) {
            ptln "\n    [** $$repo{name} **]";
            my $repourl = "https://$user:$pass\@bitbucket.org/yarec/$$repo{name}";
            sysexec "hg clone $repourl /upg/$$repo{name}";
        }
    }
    else{
        my @upgs = glob('/upg/*');
        sysexec 'mkdir -p /tmp/upg';
        foreach my $repo (@upgs) {

            ptln "\n    [** $repo **]";
            if(-e "$repo/.hg"){
                $repo = basename($repo);

                my $repourl = "https://$user:$pass\@bitbucket.org/yarec/$repo";
                my $_cmd = '';
                eval '$_cmd = '.$cmd;

                $_cmd .= ' '.$repourl;
                sysexec $_cmd;
            }
            elsif(-e "$repo/.git"){
            }
            else{
                ptln "$repo has no .hg";
            }
        }
    }

}

sub upg {

#FIXME 
    my @upgs = glob('/upg/*');

    if($opt->upg eq 'st'){
        foreach my $upg (@upgs) {
            ptln "    [** $upg **]";
            if(-e "$upg/.hg"){
                sysexec "hg -R $upg st";
            }
            elsif(-e "$upg/.git"){
                sysexec "cd $upg && git status -s && cd - >/dev/null";
            }
            else{
                ptln "$upg has no .hg";
            }
        }
    }
    elsif($opt->upg eq 'ckpull'){
        info 'ckpull';
        &hgexec('"hg -R /upg/$repo incoming --quiet "');
        #&hgexec('"hg -R /upg/$repo incoming --quiet --bundle /tmp/upg/$repo.hg"');
    }
    elsif($opt->upg eq 'ckpush'){
        info 'ckpush';
        &hgexec('"hg -R /upg/$repo outgoing --quiet --template {node} "');
    }
    elsif($opt->upg eq 'pull'){
        info 'pull';
#        sysexec "hg pull -R $$repo{name} $repourl";
#        sysexec "hg up";
    }
    elsif($opt->upg eq 'push'){
        info 'push';
        #sysexec "hg push -R $$repo{name} $repourl";
    }
    elsif($opt->upg eq 'pullall'){
        info 'pullall';
        &hgexec('', 1);
    }
    elsif($opt->upg eq 'bak'){
        info 'bak';
        my $bakupg = '/tmp/upg';
        $bakupg = $args[2] if $args[2];
        if(-e $bakupg){
            foreach my $upg (@upgs) {
                ptln "    [** $upg **]";

                my $repo = basename($upg);
                my $bakrepo = "${bakupg}/$repo";

                if(! -e $bakrepo){
                    sysexec("mkdir -p $bakrepo");
                }
                if(! -e "$bakrepo/.hg"){
                    sysexec("cd $bakrepo && hg init && cd -");
                }

                if(-e "$upg/.hg"){
                    sysexec "cd $upg && hg push $bakrepo && cd -";
                }
                elsif(-e "$upg/.git"){
                    ptln "don't push on git";
                }
                else{
                    ptln "$upg has no .hg";
                }
            }
        }
        else{
            ptln "$bakupg not found!";
        }
    }

}

#sub mvn_init () { $ENV{'PATH'} = $mvn{home}.q{/bin;}.$ENV{'PATH'}; set_java_home(); }

sub mvn_create {
    if ( hasArgs(1) && hasArgs(2)) {
        my $mvn_home = $$c{maven}{home}; 
        my $mvn_bin  = $$c{maven}{bin};
        my $m        = $mvn_home.$mvn_bin;

        my $mvn_app  = $$c{maven}{cmd}{c}{app};
        my $mvn_atf  = $$c{maven}{cmd}{c}{artifact};
        my $mvn_c    = $$c{maven}{cmd}{c}{$args[1]};
        $mvn_c       = $mvn_app." ".$mvn_c if $mvn_app ne $mvn_c;

        my $cmd = $m." ".$mvn_c." ".$mvn_atf."$args[2]";
        ptlnd($cmd);
        
        exec $cmd;

    } else { print q# Error: Please give type and name to create a mvn prj ! like "rv -cmvn app hello"#; }

    die(q{out!});
}

sub mvn_install {
    $ENV{'JAVA_HOME'} = $$c{java}{home};

    if ( $#args==4 ) {
        my $cmd = qq{/bin/mvn install:install-file -DgroupId=$args[1] -DartifactId=$args[2] -Dversion=$args[3] -Dpackaging=jar -Dfile=$args[4]};
        ptlnd($cmd);
         
        exec $$c{maven}{home}.$cmd;
    }
    elsif( $#args==1 && $args[1] eq "prj") {
        my $cmd = $$c{maven}{home}.$$c{maven}{bin}." clean install -o";
        $cmd .=" -Dmaven.test.skip=true" if("true" eq $$c{maven}{notest});
        ptlnd($cmd);

        exec $cmd;
    } else { print q# Error: The cmd must like this : 'rv -imvn groupId artifactId version file'#; }


    die(q{out!});
}

sub mvn_test_single {
    $ENV{'JAVA_HOME'} = $$c{java}{home};

    my $cmd=$$c{maven}{home}.$$c{maven}{bin}." test -e -Dtest=";
    ptln $#args;
    if($#args==0) {
        $cmd.= $$c{maven}{test};
    }
    else {
        $cmd.= $args[1];
    }
    ptlnd($cmd);

    exec $cmd;

    die(q{out!});
}

sub mvn {
    $ENV{'JAVA_HOME'} = $$c{java}{home};

    my $args= "";
    shift @args;
    foreach (@args) {
        $args.=" ".$_;
    }
    
    my $cmd = $$c{maven}{home}."/bin/mvn".$args;
    $cmd .=" -o" if("true" eq $$c{maven}{offline});
    $cmd .=" -Dmaven.test.skip=true" if("true" eq $$c{maven}{notest});
    ptlnd($cmd); 

    exec $cmd; 

    die(q{out!});
}

sub resin_server {
    if ( $args[1] && $args[1] eq "o" ) {
        exec "explorer $$c{resin}{home}\\webapps";
        die(q{out!});
    }

    set_java_home();
    my $cmd = "$$c{resin}{home}/httpd.exe";
    ptlnd($cmd);

    system $cmd;

    die(q{out!});
}

sub mvn_start_jetty {
    $ENV{'JAVA_HOME'} = $$c{java}{home};

    my $cmd = $$c{maven}{home}."/bin/mvn jetty:run-war -e ";
    $cmd .=" -o" if("true" eq $$c{maven}{offline});
    ptlnd($cmd);

    exec $cmd;

    die(q{out!});
}

sub mysql_server {
    my $cmd = "$$c{mysql}{home}$$c{mysql}{bin}";
    system $cmd;
    die(q{out!});
}

sub h2_server {
    my $cmd = "java -cp ";
    my @jars = ();

    opendir DH, "$$c{h2}{home}/bin" or die "Cannot open $$c{h2}{home}/bin : $!";
    foreach my $file (readdir DH) {
        push (@jars,"$$c{h2}{home}/bin/".$file) 
        if not -d $file 
            and $file =~/.*\.jar/;
    }
    $cmd .= join(';',@jars)." org.h2.tools.Console";

    system $cmd;
    die(q{out!});
}

sub uniq {
    if ($#args < 2) {
        ptln "Usage: wt -uniq file1 file2\n";
        exitwt();
    }

    ptlnd("args[0] $args[0]");
    ptlnd("args[1] $args[1]");
    ptlnd("args[2] $args[2]");

    open(FH,"$args[1]") or die "Couldn't open [ $args[1] ] for reading: $!";
    open(FO,">$args[2]") or die "Couldn't open [ $args[2] ] for reading: $!";

    my %e=();
    while(<FH>) {
        if (not exists $e{$_}) {
            print FO $_;
            $e{$_}=0;
        }
    }
    close(FH); 
    close(FO);
}

sub minus {

    use DBI;

    my $db_file="data.db";
    my $dbh = DBI->connect("dbi:SQLite:dbname=$db_file","","");

    $dbh->do("CREATE TABLE users(
        username varchar(255),
        password varchar(100),
        born date,
        test1 date,
        test2 varchar(500),
        test3 varchar(500),
        urlt varchar(500))");
    $dbh->do("CREATE INDEX idx_name_users ON users(username)");

    my $sth = $dbh->prepare(q{INSERT INTO users VALUES (?,?,?,?,?,?,?)});

    foreach my $i (1,2,3,4){
        $sth->bind_param(1,"ssss$i");
        $sth->bind_param(2,"passwd");
        $sth->bind_param(3,20090102);
        $sth->bind_param(4,20090102);
        $sth->bind_param(5,"none");
        $sth->bind_param(6,"none");
        $sth->bind_param(7,"http://www.supersun.biz");
        $sth->execute or die $dbh->errstr;
    }

    my $ary_ref=$dbh->selectall_arrayref(q{SELECT * FROM users});
    foreach my $entry (@$ary_ref){
        print "@$entry\n";
    }

    $dbh->disconnect;
}

sub smtp {

    my ($host, $user, $pass, $from, $tolist, $subject, $msg);

    $host       = $$c{smtp}{host};
    $user       = $$c{smtp}{user};
    $pass       = $$c{smtp}{pass};
    $from       = $$c{smtp}{from};
    $tolist     = $$c{smtp}{tolist};
    $subject    = $$c{smtp}{subject};
    $msg        = $$c{smtp}{content};

    foreach( @$host ) {
        my $l_host = $_;
        foreach( @$from ) {
            &sendmail($l_host,$user, $pass, $from, $tolist, $subject, $msg );
        }
    }
}

sub ssh {

    my $user = "";
    my $pass = "";
    my $host = "";

    if( $#args==1 ) {
        $host = $$c{ssh}{$args[1]}{host};
        $user = $$c{ssh}{$args[1]}{user};
        $pass = $$c{ssh}{$args[1]}{pass};
    }
    else {
        die qq/This option work with two parm!/;
    }

    my $wt_home = &wt_home();
    my $sshexp = "$wt_home/ssh.exp";

    my $sys_expect = `which expect`;
    if($sys_expect){
        if(! -e $sshexp){
            ptfile($sshexp, &sshscript);
            chmod 0777,$sshexp;
        }
        sysexec "$sshexp $host $user $pass";
    }
    else{
        use Expect;

        my $exp = new Expect;
        $exp->slave->clone_winsize_from(\*STDIN);
        my $command = "ssh $user\@$host";
        $exp->spawn($command);
        $exp->expect(2,[
                qr/password:/i,
                sub {
                    my $self = shift ;
                    $self->send("$pass\n");
                    exp_continue;

                }
            ],
            [
                'connecting (yes/no)',
                sub {
                    my $self = shift ;
                    $self->send("yes\n");
                }
            ]
        );
        $exp->interact();
    }
}

sub proc {

    my $grep = $$c{proc}{$args[1]}{grep};
    my $key = $$c{proc}{$args[1]}{key};
    my $proc_name = $args[1];

    my $start_cmd = "$$c{proc}{$proc_name}{startcmd}";
    my $stop_cmd = "$$c{proc}{$proc_name}{stopcmd}";

    my $pid = get_pid($grep, $key);

    if( $pid > 0 ) {
        ptln "\nproc [$proc_name] ( pid $pid ) is running";
    }
    else {
        ptln "\nproc [$proc_name] is not running";
    }

    given( $args[2] ) {
        when( 'stop' || '0' )   { 
            if($pid > 0){
                sysexec $stop_cmd; 
                &wait_proc($proc_name, 1);
            }
            break;
        }
        when ( "kill" || "k" )   { 
            if($pid > 0) {
                sysexec "kill -9 ".$pid; 
            }
            else {
                ptln "no [$proc_name] process found!";
            }
            break;
        }
        when ( "restart" || "2" )   { 
            if($pid > 0) {
                sysexec $stop_cmd;
                &wait_proc($proc_name, 1);
            }
            sysexec $start_cmd;
            &wait_proc($proc_name);
            break;
        }
        when ( "forcerestart" || "4" )   { 
            if($pid > 0) {
                sysexec "kill -9 ".$pid; 
                &wait_proc($proc_name, 1);
            }
            sysexec $start_cmd;
            &wait_proc($proc_name);
            break;
        }
        when ( "st" ) { 
            ptln $start_cmd;
            ptln $proc_name;
            break;
        } # do nothing 
        default { # start proc
            if($pid < 0){
                sysexec $start_cmd;
                &wait_proc($proc_name);
            }
        }
    }
}

sub wait_proc {

    my ( $proc_name, $stop ) = @_;

    my $grep = $$c{proc}{$proc_name}{grep};
    my $key = $$c{proc}{$proc_name}{key};
    my $timeout = $$c{proc}{timeout};
    $timeout = 30 if ! $timeout;

    my $pid = get_pid($grep, $key);
    my $msg = "starting proc $proc_name";
    debug "grep: $grep  key: $key  pid: $pid ";

    my $nums = 0;
    if($stop){
        $msg = "stoping proc $proc_name( $pid ) ";
        ptln $msg;
        while($pid > 0){
            print '.'; sleep(1);
            $pid = get_pid($grep, $key);
            $nums++;
            last if $nums > $timeout;
        } print "\n";
    }else{
        ptln $msg;
        while($pid < 0){
            print '.'; sleep(1);
            $pid = get_pid($grep, $key);
            $nums++;
            last if $nums > $timeout;
        } print "\n";
    }
}

sub sshscript {
    my $sshscript = 
'#!/usr/bin/expect -f
set timeout 30

set server [lindex $argv 0]
set user [lindex $argv 1]
set pass [lindex $argv 2]

spawn ssh $user@$server

expect {
  "> " { }
  "$ " { }
  "assword: " { 
        send "$pass\n" 
  }
  "(yes/no)? " { 
        send "yes\n"
  }
  default {
        send_user "Login failed\n"
        exit
  }
}

interact';
}


#### utils funcs 

#FIXME 
sub test {
    
}

sub printArgs {
    return if(!$debug);

    my $info = qq*
    #----------------------------------# 
    # running file: $0
    #
    #   |
    #---|/
    *;

    debug $info;

    my $num=0;
    foreach (@args) {
        $num++;
        debug "\tArgs$num : ".$_ if(defined $_);
    }
    debug "num of args: $#args";
}

sub getFStor { 
    return $^O ~~ 'MSWin32'?';':':';
};

sub hasArgs { $args[$_[0]]?1:0; }

sub is_root { return $ENV{'USER'} eq "root"; }

sub set_java_home { $ENV{'JAVA_HOME'} = $$c{java}{home} };

sub ptlnd { 
    my $debug_info = shift;
    if($debug){
        &ptln($debug_info);
#        if( not -e $$c{debug_log}) {
#            my $cmd = "echo 'init debug_log file' >> $$c{debug_log}";
#            sysexec($cmd);                                                                                        
#        }
#
#        open (MYFILE, ">>$$c{debug_log}");
#        print MYFILE "debug: ".$debug_info."\n";
#        close (MYFILE);
    }
}

sub exitwt {
    my $info = qq/ wt exit /; 

    $info="\n" if(!$debug);
    die( $info ); 
}

sub sysexec {
    my ( $s ) = @_;

    debug "exec: $s";

    if( $^O eq qq/MSWin32/ ) { exec $s; }
    else { system $s; }
}

sub getTime {
    my $time = shift || time();
    my ($sec,$min,$hour,$mday,$mon,$year,$day,$yday,$isdst) = localtime($time);

    $year += 1900;
    $mon ++;

    $min  = '0'.$min  if length($min)  < 2;
    $sec  = '0'.$sec  if length($sec)  < 2;
    $mon  = '0'.$mon  if length($mon)  < 2;
    $mday = '0'.$mday if length($mday) < 2;
    $hour = '0'.$hour if length($hour) < 2;

    my $weekday = ('Sun','Mon','Tue','Wed','Thu','Fri','Sat')[$day];

    return { 'second' => $sec,
        'minute' => $min,
        'hour'   => $hour,
        'day'    => $mday,
        'month'  => $mon,
        'year'   => $year,
        'weekNo' => $day,
        'wday'   => $weekday,
        'yday'   => $yday
    };
}

sub sendmail {

    my ($host,$user, $pass, $from, $to_addr, $subject, $msg ) = @_;
    my $mdate = "mdate";

    use Net::SMTP;
    my $smtp = Net::SMTP->new( $host );
    if(!defined($smtp) || !($smtp)) {
        print "SMTP ERROR: Unable to open smtp session.\n";
        exitwt();
    }
    if (! ($smtp->auth( $user, $pass ) ) ) {
        &ptln ("auth error");
        exitwt();
    }
    if (! ($smtp->mail( $from ) ) ) {
        exitwt();
    }
    if (! ($smtp->recipient( ( ref($to_addr) ? @$to_addr : $to_addr ) ) ) ) {
        exitwt();
    }

    exitwt();

#    $smtp->data( $msg );
    $smtp->data();
    $smtp->datasend("To:  $to_addr\n");
    $smtp->datasend("From:  $from\n");
    $smtp->datasend("Date: $mdate\n");
    $smtp->datasend("Subject: $subject\n");
    $smtp->datasend("MIME-Version: 1.0\n");
    $smtp->datasend("Content-type: text/html\n");
    $smtp->datasend("Content-Transfer-Encoding: 7bit\n");
    $smtp->datasend("\n");
    $smtp->datasend("$msg\n\n");
    $smtp->dataend();

    $smtp->quit;
}


=head1 NAME

wt.pl - Daily Tool

=head1 SYNOPSIS

wt [options]

 Options: -{ help | open | see | enva | do7z | explorer | uniq | [cirt]mvn | runserver }

    if no option, vim will be invoke to edit a file.

    -help|?           display this help
    -open             Open sys file
                      args2->file mapping table:
                      [ default        ]   { /pl/rv.pl     }
                      [ "conf" , "cfg" ]   { /pl/conf      }
                      [ "rvrc" , "rc"  ]   { /vim/rvrc.vim }
                      [ "vimrc", "vrc" ]   { /vim/vimrc    }
    -see 
    -enva
    -do7z
    -explorer
    -uniq             replace duplicate line in file
    -smtp             send mail
    -ssh              ssh to a server
    -proc             proc start stop mgr by conf

    -mysqlserver      Start mysql server
    -h2server         Start H2 server

    -rsnserver        Start resin server
    -caserver         Start My Catalyst Server
    -tomcat           Start tomcat server

    -mvn option       Exec mvn command
    -cmvn             Create mvn project
    -imvn             Install jar to respo
    -rmvn             Start jetty server(mvn plugin)
    -tmvn option      Exec mvn test [ default all | give one Test Class ]

 Examples:
     $wt file.txt
     $wt -tomcat
     $wt -tomcat s (shutdown tomcat)

 See also:
    Nothing Here!

=head1 DESCRIPTION

Invoke some other util command or program via this wt interface

Some detail description

=head1 AUTHOR

Rentie <rwtest@gmail.com>
Maintained by myself.

=head1 COPYRIGHT

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
