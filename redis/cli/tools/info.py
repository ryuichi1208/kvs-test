import redis

r = redis.Redis(host='redis001', port=6379, db=0)
r.set('hoge', 'moge')
hoge = r.get('hoge')
print(hoge.decode())
