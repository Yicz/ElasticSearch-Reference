## G1GC check

Early versions of the HotSpot JVM that shipped with JDK 8 are known to have issues that can lead to index corruption when the G1GC collector is enabled. The versions impacted are those earlier than the version of HotSpot that shipped with JDK 8u40. The G1GC check detects these early versions of the HotSpot JVM.
