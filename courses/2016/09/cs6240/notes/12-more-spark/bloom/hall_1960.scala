
import collection.immutable.BitSet

import org.apache.spark.SparkContext
import org.apache.spark.SparkContext._
import org.apache.spark.SparkConf
import org.apache.spark.rdd.RDD

object Hall1960 {
    def main(args: Array[String]) {
        val conf = new SparkConf().
            setAppName("Hall of Fame 1960").
            setMaster("local")
        val sc = new SparkContext(conf)

        val hof = sc.textFile("baseball/HallOfFame.csv").
            map( line => line.split(",") )
       
        val uhof = hof.map( xs => xs(0) ).distinct()

        val hof_size  = hof.count
        val uhof_size = uhof.count
        
        val sets  = hof.map( xs => bloomHash(xs(0)) )
        val bloom = sets.reduce((aa, bb) => aa ++ bb)

        val bloom_size = bloom.size

        val players = sc.textFile("baseball/Master.csv").
            map( line => line.split(",") )

        val player_size = players.count

        val ps1 = players.filter( pp => inBloom(bloom, pp(0)) )
       
        val filtered_size = ps1.count

        val hofp = players.keyBy( _(0) ).join(hof.keyBy( _(0) ))

        val hofp_size = hofp.count
        
        val hofp1 = ps1.keyBy( _(0) ).join(hof.keyBy( _(0) ))
        val hofp1_size = hofp1.count
        
        hofp.saveAsTextFile("output")

        sc.stop()

        println("")
        println("hof_size = " + hof_size)
        println("uhof_size = " + uhof_size)
        println("bloom_size = " + bloom_size)
        println("player_size = " + player_size)
        println("filtered_size = " + filtered_size)
        println("hofp_size = " + hofp_size)
        println("hofp1_size = " + hofp1_size)
        println("")

    }

    def bloomHash(xx: String) : BitSet = {
        val hash = xx.hashCode().abs
        BitSet.empty + ((hash >> 0) % 65536) + ((hash >> 16) % 65536)
    }

    def inBloom(bloom: BitSet, xx: String) : Boolean = {
        val item = bloomHash(xx)
        (bloom & item) == item
    }
}


// vim: set ts=4 sw=4 et:
