This project builds off of Lab2_embedded, where the goal this time is to:

    Utilize hardware timers for periodic event ISRs, alleviating the scheduler
    Remove busy waiting for main threads by implementing the block state
    Handle soft-deadline thread execution with the sleep state
    Provide a secure producer/consumer read/write buffer for sensor data

os.c:

    Add onto existing thread control block structure the block and sleep state
    Update scheduler to skip blocked and sleeping threads and remove periodic thread execution
    Update semaphore logic to block and suspend on unavailable resources and signal blocked threads
    Introduce hardware timers to decrement time of sleeping threads AND 
    run high priority hard-deadline periodic event threads
    Update producer/consumer communication to involve a fixed FIFO buffer: 
    - Discard buffer entry after retrieval, block if empty
    - Insert buffer entry, overwriting old data, unless full then discard new data

osasm.s:
  
    Remains the same from Lab2_Embedded

This is an improvement from the previous OS implementation, we take advantage of hardware to handle event deadlines for the accelerometer and microphone sensor, reducing jitter. CPU execution is relinquished by introducing sleep for slower tasks like the light sensor and block threads that seek unavailable resources/access in case of interrupts. It is also more efficient now for producers/consumers to produce and consume data, using a buffer.

Testing consisted of using Keil uVisions debugger and watch window as well as my own logic analyzer to track pin activity.
