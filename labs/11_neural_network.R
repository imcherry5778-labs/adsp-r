# Lab 11 — node 하나의 계산과 activation 비교 (약 15분)
# 이 파일만 위에서 아래로 실행하면 된다. 작은 숫자만 사용한다.

# 1. 목표 --------------------------------------------------------
# - input, weight, bias, activation function의 역할을 구분한다.
# - 입력 × weight의 합에 bias를 더해 z를 직접 계산한다.
# - 같은 z에서 sigmoid, tanh, ReLU의 값과 범위를 비교한다.

# 2. 핵심 개념과 작은 예제 ----------------------------------------
# node는 입력을 받아 계산한 값을 다음으로 전달하는 단위이다.
# 신경망은 이런 node들을 연결한다. 여기서는 node 하나의 계산만 다룬다.
# input은 들어오는 값, weight는 각 입력의 영향에 곱해지는 값이다.
# bias는 입력 × weight의 합(weighted sum)에 더해지는 값이다.
# activation function은 그 합에 bias를 더한 z를 변환한다.
# 순서: 입력 × weight → 합 → bias 추가(z) → activation 적용.

# 작은 예제: 입력 (2, -1), weight (0.5, 1.5), bias 0.5.
# z = 2 × 0.5 + (-1) × 1.5 + 0.5이다. 실행 전에 손으로 계산해 보세요.
# 아래 함수의 x는 activation에 들어가는 z이다. 원래 입력 두 개와 구분한다.
sigmoid <- function(x) 1 / (1 + exp(-x))
relu <- function(x) pmax(0, x)
# tanh는 R의 tanh()를 그대로 사용한다.

# 3. 먼저 예상하기 -----------------------------------------------
# 예상 1: 위 예제의 두 곱, weighted sum, z는 각각 얼마인가?
# 예상 2: z = 0이면 sigmoid, tanh, ReLU의 출력이 모두 0일까?
# 예상 3: z = -2와 2를 넣으면 어떤 함수가 음수를 출력할 수 있을까?
#         ReLU(-2)는 -2일까, 0일까?

# 4. 직접 실행 ----------------------------------------------------
# 실험 A: 입력별 곱을 확인한 다음 합과 bias를 구분한다.
inputs <- c(2, -1)
weights <- c(0.5, 1.5)
bias <- 0.5
weighted_inputs <- inputs * weights
cat("입력별 계산: input × weight를 읽으세요.\n")
print(data.frame(input = inputs, weight = weights, product = weighted_inputs))
# product는 1과 -1.5이다. 두 입력에 같은 weight를 곱한 것이 아니다.

weighted_sum <- sum(weighted_inputs)
z <- weighted_sum + bias
cat("합 → bias 추가 → z:\n")
print(c(weighted_sum = weighted_sum, bias = bias, z = z))
# weighted_sum은 -0.5, bias는 0.5이므로 z = 0이다.
# weight는 곱할 때, bias는 합에 더할 때 사용했다.

cat("같은 z = 0에 세 activation을 적용한 결과:\n")
print(c(sigmoid = sigmoid(z), tanh = tanh(z), ReLU = relu(z)))
# sigmoid(0) = 0.5, tanh(0) = 0, ReLU(0) = 0이다.
# z와 activation 출력은 다른 단계의 값이다. 같은 z라도 함수에 따라 달라진다.

# 실험 B: 음수·0·양수를 같은 순서로 넣고 각 행을 가로로 비교한다.
z_values <- c(-2, 0, 2)
activation_values <- data.frame(
  z = z_values, sigmoid = sigmoid(z_values),
  tanh = tanh(z_values), ReLU = relu(z_values)
)
cat("z의 부호에 따른 activation 비교:\n")
print(round(activation_values, 3))
# z = -2 행: sigmoid 약 0.119, tanh 약 -0.964, ReLU 0이다.
# z = 0 행: 0.5, 0, 0이다. z = 2 행: 약 0.881, 0.964, 2이다.
# sigmoid의 이론적 범위는 유한한 z에서 0 < 출력 < 1이다.
# tanh의 이론적 범위는 유한한 z에서 -1 < 출력 < 1이며 음수도 가능하다.
# ReLU는 음수 z를 0으로, 0 이상인 z를 그 값 자체로 출력한다. 상한은 없다.

# 5. 결과 해석 ----------------------------------------------------
# 입력의 영향은 weight, 합에 더하는 이동량은 bias, z의 변환은 activation이다.
# 표에서는 z의 부호와 각 함수의 출력 범위를 먼저 읽는다.
# sigmoid 출력이 0과 1 사이여도 모든 node의 값이 자동으로 확률이 되지는 않는다.
# 특정 모형에서 확률로 해석하도록 정의했는지와 함수의 범위는 구분해야 한다.
# 이번 숫자는 node의 계산 결과이며 어떤 사건의 확률로 정의하지 않았다.

# 6. 하나 바꿔보기 ------------------------------------------------
# inputs와 weights는 유지하고 bias만 0.5 → 1.5로 바꾼다.
# 예상: weighted_sum도 바뀔까? z는 얼마나 늘고 각 activation은 무엇을 출력할까?
bias_changed <- 1.5
z_changed <- weighted_sum + bias_changed
cat("bias만 바꾼 전후 비교:\n")
print(round(data.frame(
  bias = c(bias, bias_changed), z = c(z, z_changed),
  sigmoid = sigmoid(c(z, z_changed)), tanh = tanh(c(z, z_changed)),
  ReLU = relu(c(z, z_changed))
), 3))
# weighted_sum은 -0.5로 같고 z는 0 → 1이다.
# 출력은 sigmoid 0.5 → 약 0.731, tanh 0 → 약 0.762, ReLU 0 → 1이다.
# bias를 1 늘렸다고 모든 activation 출력도 1 늘어나는 것은 아니다.

# 7. 시험 체크 ----------------------------------------------------
# 1) input, weight, bias, activation function은 각각 어떤 역할인가?
# 2) 입력 (2, -1), weight (0.5, 1.5), bias 0.5일 때 z는 얼마인가?
# 3) 유한한 z에서 sigmoid와 tanh의 이론적 범위는? z = 0일 때 값은?
# 4) ReLU(-2), ReLU(0), ReLU(2)는? 출력의 상한은 1인가?
# 5) sigmoid 출력 0.8만 보고 특정 사건의 확률이 80%라고 해석할 수 있는가?

# 정답 및 해설 ----------------------------------------------------
# 1) input은 들어오는 값, weight는 입력에 곱하는 값, bias는 합에 더하는 값이다.
#    activation function은 weighted sum + bias인 z를 변환한다.
# 2) 1 - 1.5 + 0.5 = 0이다. activation 적용 전의 값이다.
# 3) sigmoid는 (0, 1), tanh는 (-1, 1)이다. 0에서는 각각 0.5와 0이다.
# 4) 각각 0, 0, 2이다. 0 이상은 그대로 출력하므로 상한 1이 없다.
# 5) 아니다. 함수의 범위만으로 확률 해석이 정해지지는 않는다.
#    해당 모형이 그 출력을 어떤 사건의 확률로 정의했는지 확인해야 한다.
