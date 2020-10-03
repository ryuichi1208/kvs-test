from functools import wraps
import time
import redis

r = redis.Redis(host='redis001', port=6379, db=0)

def stop_watch(func) :
    @wraps(func)
    def wrapper(*args, **kargs) :
        start = time.time()
        result = func(*args,**kargs)
        process_time =  time.time() - start
        print(f"{func.__name__} {process_time}[s]")
        return result
    return wrapper

@stop_watch
def many_set():
    for i in range(10000):
        r.set(i, i)

@stop_watch
def all_keys():
    keys = r.keys("*")

@stop_watch
def many_del():
    r.flushall()

# many_set()
# all_keys()
# many_del()

def message_queue():
    job1 = r.brpoplpush("queueA", "queueB")
    # ret = job1を使った処理
    ret = False
    if ret: # 成功したら
        r.delete("queueB")
    elif not ret:
        print(job1)
        r.rpoplpush("queueB", "queueA")

message_queue()
