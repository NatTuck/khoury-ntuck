import org.apache.spark.SparkContext
import org.apache.spark.SparkConf

object MmulCells {
    def main(args: Array[String]) {
        val conf = new SparkConf().setAppName("mmul").setMaster("local")
        val sc   = new SparkContext(conf)

        val (dataA, nn) = readMatrix(sc, "../data/dataA.txt")
        val (dataB, _m) = readMatrix(sc, "../data/dataB.txt")

        val nrange = (0 : Long) to (nn - 1)

        val distA = dataA.flatMap( cell => {
            val ((ii, kk), vv) = cell
            nrange.map(jj => ((ii, jj, kk), vv))
        })

        val distB = dataB.flatMap( cell => {
            val ((kk, jj), vv) = cell
            nrange.map(ii => ((ii, jj, kk), vv))
        })

        val distC = distA.join(distB).map( cell => {
            val ((ii, jj, kk), (aa, bb)) = cell
            ((ii, jj), aa * bb)
        })

        val cellC = distC.reduceByKey( (xx, yy) => xx + yy )

        val dataC = cellC.map( cell => {
            val ((ii, jj), vv) = cell
            (ii, (jj, vv))
        }).groupByKey.sortByKey(true).mapValues( xs => {
            xs.toArray.sortBy(_._1).map(_._2)
        }).map(_._2)

        dataC.map(xs => xs.mkString(" ")).saveAsTextFile("output")
        
        sc.stop()
    }

    val on_spaces = """\s+""".r

    def readMatrix(sc: SparkContext, path: String) = {
        val text = sc.textFile(path)
        val nn   = text.count()

        val data = text.zipWithIndex.flatMap( pair => {
           val (tt, jj) = pair;
           val row = on_spaces.split(tt).map( xx => Integer.parseInt(xx) )
           row.zipWithIndex.map( pair => {
               val (vv, ii) = pair;
               ((jj : Long, ii : Long), vv)
           })
        })

        (data, nn)
    }
}

// vim: set ts=4 sw=4 et:
