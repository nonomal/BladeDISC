// RUN: disc-opt --disc-transform-dialect-interpreter -cse -loop-invariant-code-motion --canonicalize -split-input-file %s | FileCheck %s


// CHECK-LABEL: @forall_to_gpu_warps
// CHECK-SAME: (%[[arg0:.*]]: memref<2x2xf16>)
func.func @forall_to_gpu_warps(%arg0: memref<2x2xf16>) {
  // CHECK-DAG: %[[c32:.*]] = arith.constant 32 : index
  // CHECK-DAG: %[[cst:.*]] = arith.constant 0.000000e+00 : f16
  // CHECK-DAG: %[[c0:.*]] = arith.constant 0 : index
  // CHECK-DAG: %[[c1:.*]] = arith.constant 1 : index
  // CHECK-DAG: %[[c2:.*]] = arith.constant 2 : index
  // CHECK-DAG: %[[c4:.*]] = arith.constant 4 : index
  // CHECK-DAG: %[[c128:.*]] = arith.constant 128 : index
  // CHECK: scf.parallel (%[[arg1:.*]], %[[arg2:.*]]) = (%[[c0]], %[[c0]]) to (%[[c4]], %[[c128]]) step (%[[c1]], %[[c1]]) {
  // CHECK:   %[[VAR0:.*]] = arith.divui %[[arg2]], %[[c32]] : index
  // CHECK:   %[[VAR1:.*]]:2 = "disc_shape.delinearize"(%[[VAR0]], %[[c2]], %[[c2]]) : (index, index, index) -> (index, index)
  // CHECK:   memref.store %[[cst]], %[[arg0]][%[[VAR1]]#0, %[[VAR1]]#1] : memref<2x2xf16>
  // CHECK:   scf.yield
  // CHECK: } {mapping = "cta-thread-mapping"}
  %cst = arith.constant 0.0e+00 : f16
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %c2 = arith.constant 2 : index
  %c4 = arith.constant 4 : index
  %c128 = arith.constant 128 : index
  scf.parallel (%arg1, %arg2) = (%c0, %c0) to (%c4, %c128) step (%c1, %c1) {
    scf.forall (%arg3, %arg4) in (%c2, %c2) {
      memref.store %cst, %arg0[%arg3, %arg4] : memref<2x2xf16>
    } {mapping = [#gpu.warp<x>, #gpu.warp<y>]}
  } {mapping = "cta-thread-mapping"}
  return
}

transform.sequence failures(propagate) {
^bb1(%arg1: !transform.any_op):
  %foreach = transform.structured.match ops{["scf.forall"]} in %arg1 : (!transform.any_op) -> !transform.any_op
  transform.disc.forall_to_gpu_warps %foreach : (!transform.any_op) -> ()
}
