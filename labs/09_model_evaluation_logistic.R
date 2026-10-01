# Lab 09 — 로지스틱 확률에서 분류 평가까지 (약 25분)
# 이 파일만 위에서 아래로 실행하면 된다. mtcars의 am을 예측한다.

# 1. 목표 --------------------------------------------------------
# - train/test를 나누고 로지스틱 예측확률과 최종 class를 구분한다.
# - confusion matrix에서 TP·FP·FN·TN을 찾아 평가지표를 계산한다.
# - Precision과 Recall의 분모, threshold와 ROC/AUC의 역할을 구분한다.

# 2. 핵심 개념과 작은 예제 ----------------------------------------
# Lab 08은 자료를 저차원에 표현했다. 이제 정답 범주를 배우는 지도학습 분류로 전환한다.
# am은 변속기 범주이다: 0 = 자동, 1 = 수동. 이번 Lab의 Positive는 1(수동)이다.
# Positive는 관심 사건의 이름이며 '더 좋다'는 뜻이 아니다.
# mpg(연비) 하나로 am을 예측한다. train은 모형 학습, test는 학습 밖의 평가에 쓴다.
# test의 am을 학습에 쓰면 처음 보는 자료에 대한 평가라는 목적이 흐려진다.

# 선형회귀는 연비 같은 연속값을 예측한다. 이 이항 로지스틱 회귀는
# 주어진 연비에서 am = 1일 확률을 예측하며, type = "response"로 그 확률을 얻는다.
# 확률을 범주로 바꾸려면 별도의 threshold(임계값)가 필요하다.
# 작은 예제: 확률 0.4는 실제 am 값도, 자동이라는 class label도 아니다.
# 기준 0.5에서는 0(자동), 기준 0.3에서는 1(수동)으로 결정한다.

# 3. 먼저 예상하기 -----------------------------------------------
# 예상 1: 예측확률 0.8에서 Positive 확률과 Negative 확률은 각각 얼마인가?
#         threshold = 0.5에서 예측 class는 무엇인가?
# 예상 2: 실제 Positive 5개 중 3개를 찾아냈고 Positive 예측은 4개라면,
#         Precision과 Recall은 각각 어떤 분모를 쓸까?
# 예상 3: 같은 예측확률에서 threshold를 0.5 → 0.3으로 낮추면
#         Positive 예측 수와 Recall이 줄어들 수 있을까?

# 4. 직접 실행 ----------------------------------------------------
# 실험 A: 32개 중 24개를 train, 나머지 8개를 test로 나눈다.
set.seed(42)
train_index <- sample(seq_len(nrow(mtcars)), size = 24)
train <- mtcars[train_index, ]
test <- mtcars[-train_index, ]

# levels를 고정해 어떤 범주의 관측이 없더라도 0/1 열을 모두 표시한다.
class_counts <- rbind(train = table(factor(train$am, levels = c(0, 1))),
                      test = table(factor(test$am, levels = c(0, 1))))
cat("train/test의 실제 class별 관측 수(0 = 자동, 1 = 수동):\n")
print(class_counts)
# train은 0이 16개, 1이 8개; test는 0이 3개, 1이 5개이다.
# 두 자료에 두 class가 모두 있다. 작은 임의 분할이어서 비율은 서로 다르다.
# seed는 재현을 위한 것이다. 이 작은 test의 점수를 안정적인 성능으로 일반화하지 않는다.

# 실험 B: train만으로 학습하고 test에서 Positive의 확률을 예측한다.
model_logistic <- glm(am ~ mpg, data = train, family = binomial)
probability <- predict(model_logistic, newdata = test, type = "response")
cat("test에서 예측한 P(am = 1)의 범위:\n")
print(range(probability))
# 약 0.067~0.994로 모두 0~1 사이이다. 모형이 예측한 확률이며 실제 정답이 아니다.

threshold <- 0.5
predicted_class <- as.integer(probability >= threshold)
cat("확률을 기준 0.5로 범주로 바꾼 결과:\n")
print(data.frame(mpg = test$mpg, actual = test$am,
                 probability = round(probability, 3), predicted = predicted_class))
# probability 열은 수동일 예측확률, predicted 열은 0/1 결정이다.
# Merc 240D: 약 0.771이므로 1로 예측했지만 actual은 0이다.
# Ferrari Dino: 약 0.321이므로 0으로 예측했지만 actual은 1이다.
# 0.5는 의사결정 기준이다. 로지스틱 회귀에 고정된 자연법칙이 아니다.
# 범주 결정에는 반올림 전 확률을 사용한다. 표의 소수 셋째 자리는 읽기 위한 표시이다.

# 실험 C: Positive와 행/열을 먼저 정하고 confusion matrix를 읽는다.
# Positive = 1(수동), Negative = 0(자동).
# 행 actual = 실제값, 열 predicted = 예측값. 이 순서를 아래에서 유지한다.
confusion <- table(actual = factor(test$am, levels = c(0, 1)),
                   predicted = factor(predicted_class, levels = c(0, 1)))
cat("confusion matrix: 행 = 실제, 열 = 예측:\n")
print(confusion)
# 실제 0 행: 예측 0의 2개는 TN, 예측 1의 1개는 FP이다.
# 실제 1 행: 예측 0의 2개는 FN, 예측 1의 3개는 TP이다.
# T/F는 맞음/틀림, P/N은 예측한 범주를 가리킨다. 실제 범주도 함께 확인한다.
TP <- confusion["1", "1"]
FP <- confusion["0", "1"]
FN <- confusion["1", "0"]
TN <- confusion["0", "0"]
cat("표에서 꺼낸 네 개의 도수:\n")
print(c(TP = TP, FP = FP, FN = FN, TN = TN))
# 표의 위치를 외우기 전에 행/열과 Positive 정의를 확인한다. 표가 전치될 수도 있다.

# 실험 D: 직접 계산하며 각 분모의 대상을 읽는다.
accuracy <- (TP + TN) / (TP + FP + FN + TN)
precision <- TP / (TP + FP)
recall <- TP / (TP + FN)
specificity <- TN / (TN + FP)
f1 <- 2 * precision * recall / (precision + recall)
metrics <- c(Accuracy = accuracy, Precision = precision,
             Recall = recall, Specificity = specificity, F1 = f1)
cat("threshold = 0.5의 분류 지표:\n")
print(round(metrics, 3))
# Accuracy = 5/8 = 0.625: 전체 중 맞춘 비율이다.
# Precision = 3/4 = 0.750: '수동이라고 예측한' 4개 중 실제 수동 3개이다.
# Recall = 3/5 = 0.600: '실제 수동인' 5개 중 찾아낸 수동 3개이다. Sensitivity와 같다.
# TP는 같지만 Precision의 분모는 TP + FP, Recall의 분모는 TP + FN이다.
# Specificity = 2/3 ≈ 0.667: 실제 자동(TN + FP) 중 자동으로 맞춘 비율이다.
# F1 ≈ 0.667은 Precision과 Recall의 조화평균이다. 산술평균 0.675와 구분한다.
# 어떤 지표의 분모가 0이면 그 비율을 정의할 수 없다. 0이나 1로 임의 해석하지 않는다.

# 5. 결과 해석 ----------------------------------------------------
# 관심 사건 → 예측확률 → threshold → 예측 class → 실제값과 비교 → 목적에 맞는 지표.
# Positive가 드문 자료에서는 Negative만 예측해도 Accuracy가 높을 수 있다.
# 그래서 높은 Accuracy만 보고 좋은 분류기라고 단정하지 않고 Recall 등도 함께 본다.
# Precision은 Positive 예측의 신뢰도, Recall은 실제 Positive를 놓치지 않은 정도이다.

# ROC/AUC는 개념만 구분한다. 패키지나 AUC 계산은 이번 범위에 포함하지 않는다.
# ROC는 여러 threshold에서 세로축 Sensitivity(Recall)와
# 가로축 False Positive Rate = FP/(FP + TN) = 1 - Specificity의 관계를 그린다.
# AUC는 ROC 아래의 면적으로, 여러 threshold의 구분 능력을 요약하는 지표이다.
# threshold 하나(예: 0.5)에서의 Accuracy와 같지 않다.

# 6. 하나 바꿔보기 ------------------------------------------------
# 모형·test·확률은 유지하고 threshold만 0.5에서 0.3으로 낮춘다.
# 먼저 probability가 0.3 이상 0.5 미만인 행을 찾아 어느 결정이 바뀔지 예상하세요.
lower_threshold <- 0.3
predicted_lower <- as.integer(probability >= lower_threshold)
cat("같은 확률에서 threshold만 바꾼 class:\n")
print(data.frame(probability = round(probability, 3),
                 class_at_0.5 = predicted_class, class_at_0.3 = predicted_lower))
# Ferrari Dino만 0 → 1로 바뀐다. 확률을 재학습한 것이 아니라 결정 기준을 바꾼 것이다.

confusion_lower <- table(actual = factor(test$am, levels = c(0, 1)),
                         predicted = factor(predicted_lower, levels = c(0, 1)))
cat("threshold = 0.3의 confusion matrix(같은 행/열 정의):\n")
print(confusion_lower)
TP_lower <- confusion_lower["1", "1"]
FP_lower <- confusion_lower["0", "1"]
FN_lower <- confusion_lower["1", "0"]
TN_lower <- confusion_lower["0", "0"]
precision_lower <- TP_lower / (TP_lower + FP_lower)
recall_lower <- TP_lower / (TP_lower + FN_lower)
metrics_lower <- c(
  Accuracy = (TP_lower + TN_lower) / sum(confusion_lower),
  Precision = precision_lower,
  Recall = recall_lower,
  Specificity = TN_lower / (TN_lower + FP_lower),
  F1 = 2 * precision_lower * recall_lower / (precision_lower + recall_lower)
)
cat("threshold 전후 지표 비교:\n")
print(round(rbind(threshold_0.5 = metrics, threshold_0.3 = metrics_lower), 3))
# TP는 3 → 4, FN은 2 → 1, FP와 TN은 그대로이다. Recall은 0.6 → 0.8이다.
# 이번에는 Precision도 0.75 → 0.8로 올랐다. 항상 같은 방향으로 변하는 것은 아니다.
# 같은 확률에서 기준을 낮추면 Positive 예측이 늘거나 같아진다.
# Recall은 낮아지지 않지만 FP가 늘 수 있어 Specificity는 낮아질 수 있다.
# 이 비교는 trade-off 관찰용이다. test 결과를 보고 최적 threshold를 고르는 실습은 아니다.

# 7. 시험 체크 ----------------------------------------------------
# 1) train과 test의 역할은? test의 정답을 모형 학습에 사용해도 되는가?
# 2) P(am = 1) = 0.4이면 threshold 0.5/0.3에서 class는 각각 무엇인가?
# 3) TP = 3, FP = 1, FN = 2일 때 Precision과 Recall의 분모와 값은?
# 4) TN = 2, FP = 1의 Specificity는? F1은 어떤 두 지표의 어떤 평균인가?
# 5) ROC의 두 축은? AUC는 threshold 0.5에서의 Accuracy와 같은가?

# 정답 및 해설 ----------------------------------------------------
# 1) train은 학습, test는 학습 밖의 평가용이다. test의 정답을 학습에 쓰지 않는다.
# 2) 각각 0과 1이다. 예측확률은 0.4로 같고 의사결정 기준만 달라진다.
# 3) Precision은 TP + FP = 4로 나눈 0.75, Recall은 TP + FN = 5로 나눈 0.6이다.
# 4) TN/(TN + FP) = 2/3이다. F1은 Precision과 Recall의 조화평균이다.
# 5) 가로축 1 - Specificity, 세로축 Sensitivity이다. AUC는 ROC를 요약하므로
#    한 threshold에서의 Accuracy와 다르다.
