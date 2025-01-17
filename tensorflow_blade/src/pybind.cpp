// Copyright 2022 The BladeDISC Authors. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include <pybind11/pybind11.h>

#include <iomanip>
#include <sstream>
#include <string>

#include "src/tf_compatible_version.h"

#if BLADE_WITH_INTERNAL
#include "tf_blade/internal/pybind_functions.h"
#endif  // BLADE_WITH_INTERNAL

#if BLADE_WITH_TENSORRT
#include "src/tensorrt/pybind_functions.h"
#endif  // BLADE_WITH_TENSORRT

PYBIND11_MODULE(_tf_blade, m) {
  m.doc() = "Utils for tf blade.";
  m.def("compatible_tf_version", &compatible_tf_version);
#if BLADE_WITH_TENSORRT
  tf_blade::trt::initTensorRTBindings(m);
#endif  // BLADE_WITH_TENSORRT

#if BLADE_WITH_INTERNAL
  tf_blade::internal::initInternalBindings(m);
#endif  // BLADE_WITH_INTERNAL
}
