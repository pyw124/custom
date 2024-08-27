import subprocess
import re


def get_ping(ip):
    t = subprocess.run(['ping', ip, '-c', '2', '-i', '0.5'], capture_output=True)
    if t.returncode == 0:
        last_line = t.stdout.splitlines()[-1].decode("utf-8")
        print(ip, last_line)
        m = re.match(r'([^=]+)= +([0-9./]+) +ms', last_line)
        if m:
            s = m.group(2).split('/')
            avg_ms = int(float(s[1]))
            if avg_ms < 1:
                avg_ms = 1
            return avg_ms
    else:
        return 10000


if __name__ == "__main__":
    cf_ping = get_ping("1.1.1.1")
    google_ping = get_ping("8.8.8.8")
    quad9_ping = get_ping("9.9.9.9")
    results = [("1.1.1.1", cf_ping), ("8.8.8.8", google_ping), ("9.9.9.9", quad9_ping)]
    results = sorted(results, key=lambda x: x[1])
    for t in results:
        print(t[0], 'DNS PING', t[1], 'ms')
    with open('/root/dns.config', "w") as f:
        f.write('options timeout:1 attempts:1 rotate\n')
        for t in results[:2]:
            f.write('nameserver {}\n'.format(t[0]))
