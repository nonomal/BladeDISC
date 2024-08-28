module attributes {tf.versions = {bad_consumers = [], min_consumer = 0 : i32, producer = 0 : i32}} {
  func.func @main(%arg0: tensor<?x?xf16>, %arg1: tensor<?x?xf16>) -> (tensor<?x?xf16>, tensor<?x?xf16>) attributes {tf.entry_function = {inputs = "input0,input1", outputs = "output0,output1", input_placements="cpu,cpu", output_placements="gpu,gpu"}} {
    %graph:2 = tf_executor.graph {
      %0:2 = tf_executor.island wraps "tf.Identity"(%arg0) {device = ""} : (tensor<?x?xf16>) -> tensor<?x?xf16>
      %1:2 = tf_executor.island wraps "tf.Identity"(%arg1) {device = ""} : (tensor<?x?xf16>) -> tensor<?x?xf16>
      tf_executor.fetch %1, %0 : tensor<?x?xf16>, tensor<?x?xf16>
    }
    return %graph#0, %graph#1 : tensor<?x?xf16>, tensor<?x?xf16>
  }
}