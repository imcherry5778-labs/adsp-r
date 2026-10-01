# Lab 10 — 분류 트리의 경로와 앙상블 구분 (약 25분)
# 이 파일만 위에서 아래로 실행하면 된다. iris는 R의 내장 자료이다.

# 1. 목표 --------------------------------------------------------
# - 작은 분류 트리에서 root → 분기 → terminal node의 경로를 읽는다.
# - 입력 하나를 바꾸고 예측이 달라지는 분기 조건을 찾는다.
# - 단일 트리, Bagging, Random Forest, Boosting의 학습 방식을 구분한다.

# 2. 핵심 개념과 작은 예제 ----------------------------------------
# iris의 네 수치 변수는 꽃받침(Sepal)·꽃잎(Petal)의 길이/너비(cm)이다.
# Species는 정답 범주(setosa, versicolor, virginica)인 factor이다.
# Lab 09처럼 실제 범주와 예측 범주를 비교하는 지도학습 분류이다.
cat("처음 세 꽃의 측정값과 실제 품종:\n")
print(iris[1:3, ])
# Species가 예측 대상이다. 네 측정값은 분기 조건을 만들 때 사용할 predictor이다.

# decision tree는 조건에 따라 자료를 반복해서 나눈다(recursive splitting).
# root는 모든 학습 관측이 모인 시작 노드, terminal node는 더 나누지 않는 말단이다.
# 새 관측은 root부터 조건을 따라 이동하며 도착한 말단의 범주로 예측한다.
# 작은 조건 예: Petal.Length < 2.45이면 왼쪽, 그렇지 않으면 오른쪽으로 간다.
# 2.0은 TRUE, 4.3은 FALSE이다. 등호인 2.45도 '<' 조건에서는 FALSE이다.

# 3. 먼저 예상하기 -----------------------------------------------
# 예상 1: Petal.Length = 4.3인 꽃은 위 조건의 어느 쪽으로 갈까?
# 예상 2: 다음 노드의 조건이 Petal.Width < 1.75라면 너비 1.3은 어느 쪽인가?
#         너비만 1.8로 바꾸면 같은 말단에 도착할까?
# 예상 3: 여러 트리를 만든다는 점만으로 Bagging과 Boosting이 같은 방법일까?
#         모형을 만드는 순서가 서로에게 영향을 주는지 생각해 보세요.

# 4. 직접 실행 ----------------------------------------------------
# 실험 A: 사용할 수 있을 때 rpart로 작은 분류 트리를 만든다.
# Species ~ .은 Species를 나머지 네 변수로 설명한다는 뜻이다.
# maxdepth = 2로 경로에서 최대 두 번만 분기한다. cp = 0으로 교육용 깊이 제한 안에서 분기를 미리 막지 않고, xval = 0으로 별도 재표집 계산은 생략한다.
# 이번에는 분기 읽기에 집중하므로 iris 전체로 적합한다. test 성능을 평가하는 실험은 아니다.
tree_available <- requireNamespace("rpart", quietly = TRUE)
if (tree_available) {
  tree_model <- rpart::rpart(
    Species ~ ., data = iris, method = "class",
    control = rpart::rpart.control(maxdepth = 2, cp = 0, xval = 0)
  )
  cat("분류 트리: 노드 번호, 분기 조건, 말단의 * 표시를 찾으세요.\n")
  print(tree_model)
  # 1) root에서 시작한다. 2)와 3)은 첫 분기, 6)과 7)은 다음 분기이다.
  # Petal.Length < 2.45가 TRUE이면 왼쪽 2), FALSE이면 오른쪽 3)으로 이동한다.
  # 3)에서는 Petal.Width < 1.75를 판단한다: TRUE이면 6), FALSE이면 7)이다.
  # *가 붙은 2), 6), 7)은 말단이다. yval의 setosa/versicolor/virginica가 예측 범주이다.
  # 중간 노드에 보이는 범주에서 멈추지 않고 말단까지 간다.

  plot(tree_model, uniform = TRUE, margin = 0.1)
  text(tree_model, all = TRUE, use.n = FALSE, cex = 0.85)
  title(main = "iris: Species")
  # 노드 위의 '<'는 왼쪽으로 갈 조건이다. TRUE이면 왼쪽, FALSE이면 오른쪽으로 간다.
  # 분기 변수는 모델이 선택했다. 네 predictor가 모두 그림에 나와야 하는 것은 아니다.

  # 실험 B: 꽃 하나의 경로를 손으로 따라간 뒤 predict()로 확인한다.
  flower <- iris[75, ]
  cat("경로를 따라갈 75번 꽃:\n")
  print(flower)
  # Petal.Length 4.3: 4.3 < 2.45는 FALSE → 오른쪽 3).
  # Petal.Width 1.3: 1.3 < 1.75는 TRUE → 왼쪽 6) 말단 → versicolor.
  # 위 경로의 예측을 먼저 말한 뒤 아래 결과를 확인하세요.
  flower_prediction <- predict(tree_model, newdata = flower, type = "class")
  cat("말단에서 얻은 예측과 실제값:\n")
  print(data.frame(actual = flower$Species, predicted = flower_prediction))
  # 둘 다 versicolor이다. 실제값을 그대로 복사한 것이 아니라 분기 경로로 예측한 결과이다.
  # 말단에 여러 실제 품종이 섞여 있을 수도 있다. 같은 말단의 예측이 모두 맞지는 않는다.
} else {
  cat("rpart가 없어 트리 적합·그림·예측 실행을 건너뜁니다.\n")
  cat("아래는 경로 읽기용 예시이며, 이 환경에서 적합한 결과는 아닙니다.\n")
  cat("root: Petal.Length < 2.45?\n",
      "  TRUE  → 왼쪽 말단: setosa\n",
      "  FALSE → 오른쪽: Petal.Width < 1.75?\n",
      "    TRUE  → 왼쪽 말단: versicolor\n",
      "    FALSE → 오른쪽 말단: virginica\n", sep = "")
  # 75번 꽃의 꽃잎 길이 4.3, 너비 1.3을 예시에 넣으면 FALSE → TRUE → versicolor이다.
  # 실제 트리 실행을 생략해도 다음 앙상블 비교와 시험 체크는 계속 공부할 수 있다.
}

# 실험 C: 앙상블은 만드는 방법을 비교한다. 별도 모형 패키지는 사용하지 않는다.
# 앙상블은 여러 모형의 결과를 결합하는 방법이다.
# bootstrap 표본: 원래 학습 자료에서 복원추출한 표본이다.
# 같은 관측이 여러 번 뽑히거나 어떤 관측은 빠질 수 있다.
# Bagging은 여러 bootstrap 표본에서 모형을 독립적으로 학습한 뒤 결과를 결합한다.
# Random Forest는 트리 Bagging에 각 split의 후보 predictor 일부를
# 무작위로 선택하는 절차를 더한다. '트리마다 변수 하나만 고정'하는 뜻이 아니다.
# Boosting은 이전 모형이 잘 처리하지 못한 부분을 다음 모형이 보완하도록 순차 학습한다.
# 오분류 관측의 가중치를 늘리는 방식은 한 예이며 모든 Boosting의 정의는 아니다.
cat("트리 기반 방법의 차이:\n")
print(data.frame(
  learning = c("한 트리 적합", "bootstrap, 독립", "bootstrap, 독립", "오류 보완, 순차"),
  split_candidates = c("전체 predictor", "전체 predictor", "매 분기 무작위 일부", "구현에 따라 다름"),
  row.names = c("단일 트리", "Bagging", "Random Forest", "Boosting")
))
# Bagging과 Random Forest의 표본 방식은 비슷하지만 split 후보 방식은 다르다.
# 독립 학습은 이전 트리의 오류를 보고 다음 트리를 바꾸지 않는다는 뜻이다.
# Boosting은 앞 모형의 결과가 뒤 모형의 학습에 영향을 준다.

# 결합의 작은 예: 가상의 다섯 트리가 같은 꽃에 아래 범주를 예측했다고 가정한다.
# 실제로 앙상블을 학습한 결과가 아니라 분류에서의 다수결을 보여 주는 값이다.
tree_votes <- c("versicolor", "virginica", "versicolor", "versicolor", "virginica")
cat("다섯 트리의 가상 예측 도수:\n")
print(table(tree_votes))
# versicolor 3표, virginica 2표이므로 다수결 결합은 versicolor이다.
# 투표를 모으는 예만으로 Bagging인지 Random Forest인지 알 수 없다.
# 표본을 만든 방법과 split 후보 선택 방법도 알아야 한다.
# 여러 모형을 결합해도 항상 단일 트리보다 더 정확하다는 보장은 없다.

# 5. 결과 해석 ----------------------------------------------------
# 트리 그림은 root의 조건부터 판단해 말단의 예측을 읽는다.
# 예측 범주와 실제 Species는 서로 다른 값이다. 정답 여부는 둘을 비교해서 판단한다.
# 앙상블의 결합 결과만 보지 말고 표본 방식·모형 간 학습 순서·분기 후보를 비교한다.

# 6. 하나 바꿔보기 ------------------------------------------------
# 모형은 유지하고 75번 꽃의 Petal.Width만 1.3에서 1.8로 바꾼다.
# 예상: root의 이동은 같은가? 두 번째 조건과 최종 예측은 어떻게 바뀔까?
if (tree_available) {
  changed_flower <- flower
  changed_flower$Petal.Width <- 1.8
  changed_prediction <- predict(tree_model, newdata = changed_flower, type = "class")
  cat("꽃잎 너비만 바꾼 가상 입력의 예측:\n")
  print(data.frame(Petal.Length = c(flower$Petal.Length, changed_flower$Petal.Length),
                   Petal.Width = c(flower$Petal.Width, changed_flower$Petal.Width),
                   predicted = c(as.character(flower_prediction),
                                 as.character(changed_prediction))))
  # 꽃잎 길이는 4.3으로 같아 root에서는 여전히 오른쪽 3)으로 간다.
  # 1.8 < 1.75는 FALSE → 오른쪽 7) 말단 → virginica로 예측이 바뀐다.
  # 원래 꽃의 실제 품종이 바뀌었다는 뜻이 아니다. 입력을 바꾼 가상 조건의 예측이다.
} else {
  cat("rpart가 없어 변경 입력의 predict()도 생략합니다.\n")
  # 위 개념용 예시에서는 길이 4.3 → FALSE, 너비 1.8 → FALSE → virginica이다.
}

# 7. 시험 체크 ----------------------------------------------------
# 1) root의 Petal.Length < 2.45가 FALSE, 다음 Petal.Width < 1.75가 TRUE이면
#    이번 트리 예시에서 어떤 품종의 말단에 도착하는가?
# 2) root와 terminal node는 무엇인가? 출력의 *는 무엇을 표시하는가?
# 3) Bagging의 bootstrap 표본과 모형 학습·결합은 어떻게 이루어지는가?
# 4) Random Forest가 트리 Bagging에 추가하는 무작위성은 무엇인가?
# 5) Boosting과 Bagging은 모형을 만드는 순서에서 어떻게 다른가?

# 정답 및 해설 ----------------------------------------------------
# 1) root에서 오른쪽 3), 다음에 왼쪽 6)으로 가서 versicolor 말단에 도착한다.
# 2) root는 시작 노드, terminal node는 더 나누지 않는 말단이다. *는 말단 표시이다.
# 3) 복원추출한 여러 표본에서 모형을 독립적으로 학습하고, 투표 등으로 결과를 결합한다.
# 4) 각 split에서 predictor 일부를 무작위 후보로 선택한다.
#    단일 트리와 달리 여러 트리를 결합하며, 표본의 무작위성만 쓰는 것과 구분한다.
# 5) Bagging은 독립 학습 후 결합, Boosting은 이전 모형의 오류를 보완하는 순차 학습이다.
#    Boosting 전체를 특정 구현의 '오분류 가중치 증가'만으로 정의하지 않는다.
