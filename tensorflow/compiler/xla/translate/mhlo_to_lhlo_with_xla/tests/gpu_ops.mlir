// RUN: xla-translate-gpu-opt -split-input-file -xla-hlo-to-lhlo-with-xla=platform=CUDA %s | FileCheck %s

// CHECK-LABEL: func @main
// CHECK-SAME: %[[ARG0:.*]]: memref<36xi8> {lmhlo.params = 0
// CHECK-SAME: %[[ARG1:.*]]: memref<8xi8>
// CHECK-SAME: %[[ARG2:.*]]: memref<24xi8>
// CHECK-SAME: %[[ARG3:.*]]: memref<36xi8>
// CHECK-DAG: %[[VIEW0:.*]] = memref.view %[[ARG0]]{{.*}} : memref<36xi8> to memref<3x3xi32>
// CHECK-DAG: %[[VIEW3:.*]] = memref.view %[[ARG3]]{{.*}} : memref<36xi8> to memref<3x3xi32>
// CHECK: %{{.*}} = mhlo.copy %{{.*}}
// CHECK-DAG: %[[VIEW1:.*]] = memref.view %[[ARG1]]{{.*}} : memref<8xi8> to memref<2x1xi32>
// CHECK-DAG: %[[VIEW2:.*]] = memref.view %[[ARG2]]{{.*}} : memref<24xi8> to memref<2x1x3xi32>
// CHECK:  "lmhlo.scatter"(%[[VIEW3]], %[[VIEW1]], %[[VIEW2]], %[[VIEW3]])
// CHECK:  mhlo.add
// CHECK: indices_are_sorted = false
// CHECK: update_window_dims = [1, 2]
// CHECK-NOT: inserted_window_dims
// CHECK: scatter_dims_to_operand_dims = [0]
// CHECK: index_vector_dim = 1
// CHECK: unique_indices = false
// CHECK: (memref<3x3xi32>, memref<2x1xi32>, memref<2x1x3xi32>, memref<3x3xi32>) -> ()
func.func @main(%operand:tensor<3x3xi32>, %indices: tensor<2x1xi32>, %updates: tensor<2x1x3xi32>) -> tensor<3x3xi32> {
  %result = "mhlo.scatter"(%operand, %indices, %updates) ({
    ^bb0(%x: tensor<i32>, %y : tensor<i32>):
      %result = "mhlo.add"(%x, %y): (tensor<i32>, tensor<i32>) -> tensor<i32>
      "mhlo.return"(%result) : (tensor<i32>) -> ()
    }) { scatter_dimension_numbers = #mhlo.scatter<
           update_window_dims = [1, 2],
           inserted_window_dims = [],
           scatter_dims_to_operand_dims = [0],
           index_vector_dim = 1,
         >,
         indices_are_sorted = false,
         unique_indices = false} : (tensor<3x3xi32>, tensor<2x1xi32>, tensor<2x1x3xi32>) -> tensor<3x3xi32>
  func.return %result : tensor<3x3xi32>
}

