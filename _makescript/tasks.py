#!/usr/bin/env python

import inspect
import json
import os.path
import subprocess
import sys
import threading
import time as t
from datetime import *

USER = os.getenv("USER")
SUDO_USER = os.getenv("SUDO_USER")

try:
    arg1 = sys.argv[1]
except:
    arg1 = ""

print("<<start_tasks.py " + arg1 + ">>")

if USER != 'root':
    try:
        raise Exception('Script must run as Sudo ROOT')
    except Exception as e:
        print ("=============================")
        print (e.message)
        print ("=============================")
        exit(100)


class ProgressBarLoading(threading.Thread):
    def run(self):
        global pb_stop
        global pb_kill
        print ('Loading....  '),
        sys.stdout.flush()
        i = 0
        while pb_stop != True:
            if (i % 4) == 0:
                sys.stdout.write('\b/')
            elif (i % 4) == 1:
                sys.stdout.write('\b-')
            elif (i % 4) == 2:
                sys.stdout.write('\b\\')
            elif (i % 4) == 3:
                sys.stdout.write('\b|')

            sys.stdout.flush()
            t.sleep(0.2)
            i += 1

        if pb_kill == True:
            print ('\b\b\b\b ABORT!'),
        else:
            print ('\b\b done!'),


def diff_date(arr, key, time_to_diff=None):
    try:
        key_val = arr[key]
    except KeyError:
        key_val = '2001-01-01'
    try:
        key_val_time = datetime.strptime(key_val, '%Y-%m-%d')
    except:
        key_val_time = datetime.strptime('2001-01-01', '%Y-%m-%d')

    if not time_to_diff:
        time_to_diff = datetime.now()

    t_delta = (key_val_time - time_to_diff)

    return [t_delta, key_val]


pb_kill = False
pb_stop = False
pb = ProgressBarLoading()
dateTimeNow = datetime.now()


def run_command(cmd, hide_loader=None):
    global pb_stop
    global pb_kill
    print ('Running: ' + ' '.join(cmd))

    if not hide_loader:
        pb.start()

    output = None
    error = None
    try:
        res = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        output, error = res.communicate()
        pb_stop = True
        if output:
            # print "reto> ", res.returncode
            # print "OK> output ", output
            print (output)
            # pb_kill = True
            # if error:
            # print "rete> ", res.returncode
            # print "Error> error ", error.strip()
            # print error.strip()
            # pb_kill = True
            # except CalledProcessError as e:
            #   print "CalledError > ",e.returncode
            #   print "CalledError > ",e.output
        pb_kill = True
    except OSError as e:
        print ("OSError > ", e.errno)
        print ("OSError > ", e.strerror)
        print ("OSError > ", e.filename)
        error = e.strerror
        pb_kill = True
        pb_stop = True
    except:
        ex = sys.exc_info()[0]
        print ("Error > ", ex)
        error = ex
        pb_kill = True
        pb_stop = True

    return [output, error]


if '__file__' not in locals():
    __file__ = inspect.getframeinfo(inspect.currentframe())[0]

_dri = os.path.dirname(os.path.abspath(__file__))
_abs_dir = os.path.abspath(_dri + "/../")

filename = _dri + '/meta.txt'
filenameMode = 'r+' if os.path.exists(filename) else 'w+'

with open(filename, filenameMode) as metaF:
    os.chmod(filename, 0o777)
    s = metaF.read()

if not s:
    s = '{}'
try:
    sj = json.loads(s)
except:
    sj = json.loads('{}')


def github():
    ##############################################
    ### GITHUB
    global sj
    K = 'github_up'
    gh_delta = diff_date(sj, 'github_up')
    # [1] time in format, [0] time in object
    sj[K] = gh_delta[1]

    git_up = None
    if gh_delta[0].days < -1:
        git_up = True
        ## update github
        print ("Update " + K)
        out = run_command(["sudo", "-u", SUDO_USER, "git", '--work-tree=' + _abs_dir, '--git-dir=' + _abs_dir + '/.git', 'pull', 'origin', 'master'], 1)
        print (out[1])
        sj[K] = dateTimeNow.strftime('%Y-%m-%d')


def brew():
    ##############################################
    ### BREW
    global sj
    K = 'brew_up'
    brew_delta = diff_date(sj, K)
    # [1] time in format, [0] time in object
    sj[K] = brew_delta[1]

    brew_up = None
    if brew_delta[0].days < -1:
        brew_up = True
        sj[K] = dateTimeNow.strftime('%Y-%m-%d')
        print ("Update " + K)
        ## update brew
        # out = run_command(["/bin/sleep", "2"])
        # print out[1]


if (arg1 == 'github'):
    github()
else:
    brew()

##############################################
## update the meta file
with open(filename, 'w') as metaF:
    metaF.write(json.dumps(sj))

print ("<<end_tasks.py " + arg1 + ">>")
print ("")
