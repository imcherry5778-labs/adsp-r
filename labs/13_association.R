# Lab 13 — 거래 건수로 support·confidence·lift 읽기 (약 20분)
# 이 파일만 위에서 아래로 실행하면 된다. 패키지 없이 가상 거래 건수만 사용한다.

# 1. 목표 --------------------------------------------------------
# - 공동 발생 비율인 support와 방향이 있는 confidence를 계산한다.
# - lift를 결론 항목의 기본 발생률 및 독립 기준 1과 비교한다.
# - 공동 발생 건수 하나를 바꾸고 세 지표의 변화를 해석한다.

# 2. 핵심 개념과 작은 예제 ----------------------------------------
# Lab 12는 관측치를 군집으로 나눴다. 이번에는 거래 안의 항목 동반 발생을 살핀다.
# A와 B는 가상 상품이다. itemset {A, B}는 두 항목을 함께 묶은 것이다.
# association rule A → B는 A가 포함된 거래에서 B도 포함되는 비율을 살피는 규칙이다.
# 왼쪽 A는 조건 항목, 오른쪽 B는 결론 항목(consequent)이다. B → A와 방향이 다르다.
# 이 규칙은 거래를 class로 예측하거나 cluster에 배정하는 결과가 아니다.

N <- 100
count_A <- 40
count_B <- 50
count_AB <- 30
cat("가상 거래 건수: 함께 포함된 건수는 A·B 각각의 건수에도 포함됩니다.\n")
print(c(N = N, count_A = count_A, count_B = count_B, count_AB = count_AB))
# A만 10건, B만 20건, 함께 30건, 둘 다 없는 거래 40건으로 총 100건이다.
# 작은 예: A가 있는 40건 중 함께 있는 30건의 비율은 30/40으로 계산한다.

# 3. 먼저 예상하기 -----------------------------------------------
# 예상 1: 전체 100건 중 함께 있는 30건의 비율은? 방향을 뒤집으면 달라질까?
# 예상 2: A → B의 분모 40과 B → A의 분모 50 중 어느 쪽의 비율이 더 클까?
# 예상 3: A가 있는 거래에서 B의 비율이 30/40이고 전체에서 B의 비율이 50/100이면,
#         A → B의 confidence는 B의 기본 발생률보다 얼마나 큰가?

# 4. 직접 실행 ----------------------------------------------------
# 실험 A: support는 전체 거래 중 두 항목이 함께 나타나는 비율이다.
# support(A와 B) = count_AB / N = support(B와 A).
support_AB <- count_AB / N
cat("support: 전체 거래를 분모로 읽으세요.\n")
print(support_AB)
# 30/100 = 0.30, 즉 전체 거래의 30%에 A와 B가 함께 있다.
# 공동 발생은 방향을 뒤집어도 같다. 규칙 자체에 방향이 없다는 뜻은 아니다.

# 실험 B: confidence는 조건 항목이 있는 거래를 분모로 사용한다.
confidence_A_to_B <- count_AB / count_A
confidence_B_to_A <- count_AB / count_B
cat("confidence: 각 방향에서 분모가 되는 항목을 찾으세요.\n")
print(c("A → B" = confidence_A_to_B, "B → A" = confidence_B_to_A))
# A → B: 30/40 = 0.75. A가 포함된 거래 중 75%에 B도 포함되어 있다.
# B → A: 30/50 = 0.60. B가 포함된 거래 중 60%에 A도 포함되어 있다.
# 분자는 같지만 분모가 달라 일반적으로 confidence는 방향에 따라 달라진다.
# 0.75를 'A를 사면 B를 사게 만들 확률'로 해석하지 않는다. 인과관계를 계산하지 않았다.

# 실험 C: lift는 confidence를 결론 항목의 기본 발생률과 비교한다.
support_A <- count_A / N
support_B <- count_B / N
cat("항목별 기본 발생률: 전체 거래 중 각 항목이 포함된 비율:\n")
print(c(support_A = support_A, support_B = support_B))
# A → B의 결론은 B이므로 0.50, B → A의 결론은 A이므로 0.40을 기준으로 쓴다.

lift_A_to_B <- confidence_A_to_B / support_B
lift_B_to_A <- confidence_B_to_A / support_A
cat("lift: 각 confidence를 결론 항목의 기본 발생률로 나눈 값:\n")
print(c("A → B" = lift_A_to_B, "B → A" = lift_B_to_A))
# A → B는 0.75/0.50 = 1.5: A가 있는 거래에서 B의 비율이 기본 발생률의 1.5배이다.
# B → A도 0.60/0.40 = 1.5이다. 두 방향의 confidence가 달라도 이 lift는 같다.
# 같은 A와 B의 lift는 (count_AB/N) / ((count_A/N) × (count_B/N))로도 읽을 수 있다.

# 5. 결과 해석 ----------------------------------------------------
# support는 전체 중 공동 발생, confidence는 조건 항목 중 동반 발생의 비율이다.
# lift는 결론 항목이 원래 얼마나 흔한지까지 비교한다.
# lift > 1: 독립이라고 가정했을 때보다 함께 나타나는 경향이 크다.
# lift = 1: 독립 기준과 같은 수준이다. 모든 거래에서 함께 나온다는 뜻이 아니다.
# lift < 1: 독립 기준보다 함께 나타나는 경향이 작다.
# 높은 lift도 인과관계를 증명하지 않는다. B 자체가 흔하면 confidence도 높을 수 있다.
# support가 매우 작은 규칙을 높은 lift만으로 무조건 좋은 규칙이라고 판단하지 않는다.

# 6. 하나 바꿔보기 ------------------------------------------------
# N·count_A·count_B는 유지하고 공동 발생 count_AB만 30 → 20으로 바꾼다.
# 바뀐 가상 거래는 A만 20건, B만 30건, 함께 20건, 둘 다 없음 30건이다.
# 예상: A → B의 support·confidence·lift는 줄어들까? lift는 1과 비교해 어떤가?
count_AB_changed <- 20
support_AB_changed <- count_AB_changed / N
confidence_changed <- count_AB_changed / count_A
lift_changed <- confidence_changed / support_B
cat("A → B의 공동 발생 건수만 바꾼 전후 비교:\n")
print(data.frame(
  count_AB = c(count_AB, count_AB_changed),
  support = c(support_AB, support_AB_changed),
  confidence = c(confidence_A_to_B, confidence_changed),
  lift = c(lift_A_to_B, lift_changed)
))
# support 0.30 → 0.20, confidence 0.75 → 0.50, lift 1.5 → 1이다.
# A가 있는 거래에서 B의 비율 0.50이 B의 기본 발생률 0.50과 같아졌다.
# 독립 기준의 공동 발생은 (40/100) × (50/100) = 0.20으로 이번 값과 같다.
# 건수와 비율의 일치를 확인한 것이며 상품 간 인과관계의 유무를 증명한 것은 아니다.

# 7. 시험 체크 ----------------------------------------------------
# 1) 처음 건수에서 support(A와 B)는? A와 B 순서를 바꾸면 달라지는가?
# 2) confidence(A → B)와 confidence(B → A)의 분모와 값은 각각 무엇인가?
# 3) A → B의 lift는? B → A로 뒤집으면 이번 confidence와 lift가 각각 어떻게 되는가?
# 4) N = 100, count_A = 40, count_B = 50을 유지하고 count_AB = 20이면
#    lift는 얼마인가? lift가 1보다 크거나 작으면 독립 기준과 어떻게 다른가?
# 5) 높은 confidence/lift는 인과관계의 증거인가? support가 작아도 무조건 좋은가?

# 정답 및 해설 ----------------------------------------------------
# 1) 30/100 = 0.30이다. 공동 발생 비율이므로 순서를 뒤집어도 같다.
# 2) A → B는 A의 40건으로 나눈 0.75, B → A는 B의 50건으로 나눈 0.60이다.
# 3) 0.75/0.50 = 1.5이다. 뒤집으면 confidence는 0.60, lift는 0.60/0.40 = 1.5이다.
# 4) (20/40)/(50/100) = 1로 독립 기준과 같다. 1보다 크면 공동 발생 경향이 더 크고,
#    1보다 작으면 더 작다. lift = 1은 항상 함께 발생한다는 뜻이 아니다.
# 5) 아니다. 거래의 동반 발생을 계산했으며 인과관계는 입증하지 않았다.
#    support가 작으면 드문 공동 발생이므로 높은 lift만으로 좋다고 단정하지 않는다.
