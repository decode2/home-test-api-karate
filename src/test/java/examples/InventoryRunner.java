package examples;

import com.intuit.karate.junit5.Karate;

class InventoryRunner  {
    
    @Karate.Test
    Karate testAll() {
        return Karate.run().relativeTo(getClass());
    }
}
