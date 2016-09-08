

// Check: n(n+1)*0.5

public class MillionSum {
    public static long sum = 0;

    public static void main(String[] args) throws Exception {
        Thread t1 = new WorkThread(0, 500000);
        Thread t2 = new WorkThread(5000000, 1000000);

        t1.start();
        t2.start();

        t1.join();
        t2.join();

        System.out.println("The sum is: " + sum);
    }
}

class WorkThread extends Thread {
    final long ii0;
    final long ii1;

    WorkThread(long start, long end) {
        ii0 = start;
        ii1 = end;
    }

    @Override
    public void run() {
        for (long ii = ii0; ii < ii1; ii++) {
            MillionSum.sum += ii;
        }
    }
}
