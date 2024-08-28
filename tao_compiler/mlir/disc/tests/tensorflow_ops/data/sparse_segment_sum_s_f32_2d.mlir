module attributes {tf.versions = {bad_consumers = [], min_consumer = 0 : i32, producer = 0 : i32}} {
  func.func @main(%arg0: tensor<4x4xf32>, %arg1: tensor<6xi32>, %arg2: tensor<6xi32>) -> tensor<?x4xf32> attributes {tf.entry_function = {inputs = "{{INPUTS}}", outputs = "{{OUTPUTS}}", input_placements="{{INPUT_PLACEMENTS}}", output_placements="{{OUTPUT_PLACEMENTS}}"}} {
    %graph = tf_executor.graph {
      %0:2 = tf_executor.island wraps "tf.SparseSegmentSum"(%arg0, %arg1, %arg2) : (tensor<4x4xf32>, tensor<6xi32>, tensor<6xi32>) -> tensor<?x4xf32>
      tf_executor.fetch %0#0 : tensor<?x4xf32>
    }
    return %graph : tensor<?x4xf32>
  }
}
