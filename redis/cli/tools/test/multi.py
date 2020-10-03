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
        print(f"{func.__name__:<15}: {str(process_time)[:5]}[s]")
        return result
    return wrapper


@stop_watch
def many_set():
    for i in range(10000):
        r.set(i, i)

@stop_watch
def many_get():
    for i in range(10000):
        r.get(i)

@stop_watch
def mpipe_line():
    with r.pipeline() as pipe:
        for key in range(10000):
            pipe.get(key)
        pipe.execute()

many_set()
many_get()
mpipe_line()
