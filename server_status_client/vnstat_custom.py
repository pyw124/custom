import sys
import json

if __name__ == '__main__':
    vnstat_data = sys.stdin.read()
    json_data = json.loads(vnstat_data)
    total_in = total_out = total = 0
    for it in json_data['interfaces']:
        for d in it['traffic']['day']:
            total_in += d['rx']
            total_out += d['tx']
    total = total_in + total_out
    print(total_in, total_out, total)