# Lab 03 — 결측값, 이상치 후보, 구간화 (약 25분)
# 이 파일만 위에서 아래로 실행하면 된다. airquality는 R의 내장 데이터이다.

# 1. 목표 --------------------------------------------------------
# - 결측값 개수를 확인하고 na.rm이 평균 계산에 미치는 영향을 설명한다.
# - 사분위수와 IQR로 이상치 후보를 찾고 상자그림을 읽는다.
# - cut()의 구간 경계를 읽고 경계값이 어느 범주에 속하는지 판단한다.

# 2. 핵심 개념과 작은 예제 ----------------------------------------
# NA는 값이 없거나 알려지지 않았다는 표시이며, 숫자 0이 아니다.
# is.na()는 각 값이 결측값인지 TRUE/FALSE로 알려 준다.
small_values <- c(2, NA, 4)
print(is.na(small_values))
print(sum(is.na(small_values)))
# FALSE, TRUE, FALSE이므로 결측값은 한 개이다. sum()은 TRUE를 1로 센다.
print(mean(small_values))
print(mean(small_values, na.rm = TRUE))
# 기본 평균은 NA, 결측값을 계산에서 제외한 평균은 (2 + 4) / 2 = 3이다.
# na.rm = TRUE는 0으로 채우는 것이 아니며 원자료를 바꾸지도 않는다.

# 이상치는 관측된 값 중 다른 값들과 크게 떨어진 값이다. NA와 구분한다.
# Q1과 Q3는 각각 25%, 75% 위치의 사분위수이고 IQR = Q3 - Q1이다.
# 1.5 × IQR 규칙: Q1 - 1.5 × IQR 미만, Q3 + 1.5 × IQR 초과를 후보로 본다.
# 후보라는 이유만으로 오류라고 확정하거나 자동으로 삭제하지 않는다.

# 3. 먼저 예상하기 -----------------------------------------------
# 예상 1: airquality의 Ozone에 NA가 있다면 기본 mean()은 숫자인가, NA인가?
#         na.rm = TRUE인 평균의 분모는 전체 행 수인가, 결측이 아닌 값의 수인가?
# 예상 2: 값 10, 11, 12, 13, 14, 15, 16, 17, 40에서 Q1 = 12, Q3 = 16이다.
#         IQR과 상한 Q3 + 1.5 × IQR을 계산해 보세요. 40은 후보에 해당하는가?

# 4. 직접 실행 ----------------------------------------------------
# 실험 A: airquality의 Ozone 열에서 결측값과 평균을 확인한다.
ozone <- airquality$Ozone
cat("전체 값의 수:\n")
print(length(ozone))
cat("결측값 수:\n")
print(sum(is.na(ozone)))
cat("결측이 아닌 값의 수:\n")
print(sum(!is.na(ozone)))
cat("기본 평균:\n")
print(mean(ozone))
cat("결측값을 제외한 평균:\n")
print(mean(ozone, na.rm = TRUE))
# 전체 153개 중 결측값 37개를 제외한 116개로 평균 약 42.13을 구한다.
# !는 논리값을 반대로 바꾼다. !is.na(ozone)은 결측이 아닌 위치를 뜻한다.
# 이 평균은 관측된 값들의 평균이다. 빠진 값까지 복원한 평균은 아니다.

# 실험 B: 작은 벡터에서 경계를 계산한 뒤 상자그림과 비교한다.
example_values <- c(10, 11, 12, 13, 14, 15, 16, 17, 40)
quartiles <- quantile(example_values, probs = c(0.25, 0.75))
iqr_value <- IQR(example_values)
lower_fence <- unname(quartiles[1]) - 1.5 * iqr_value
upper_fence <- unname(quartiles[2]) + 1.5 * iqr_value
cat("Q1과 Q3:\n")
print(quartiles)
cat("IQR:\n")
print(iqr_value)
cat("이상치 후보 판정의 하한과 상한:\n")
print(c(lower = lower_fence, upper = upper_fence))

is_candidate <- example_values < lower_fence | example_values > upper_fence
cat("경계 밖의 이상치 후보:\n")
print(example_values[is_candidate])
# |는 두 조건 중 하나라도 TRUE이면 TRUE이다.
# IQR은 4, 경계는 6과 22이므로 후보는 40이다.

# 상자와 수염, 별도 점을 구분한다. 점선은 직접 계산한 판정 경계이다.
boxplot(example_values, main = "1.5 * IQR", ylab = "x", ylim = c(0, 45))
abline(h = c(lower_fence, upper_fence), lty = 2, col = "gray40")
# 이 예제에서는 quantile()의 Q1/Q3와 boxplot의 hinge가 일치해 상자는 12부터 16까지이고 가운데 선은 중앙값 14이다.
# 데이터 개수에 따라 boxplot의 hinge와 quantile()의 25%/75% 값은 약간 다를 수 있다.
# 수염 끝은 후보가 아닌 실제 관측값 10과 17이다. 점선 경계 6과 22가 아니다.
# 40은 위 수염과 떨어진 점으로 표시된다. 크다는 이유만으로 결측값이 되지 않는다.

# 실험 C: 연속형 온도를 세 구간의 범주로 바꾼다(구간화).
# Temp는 화씨 온도이다. 아래 경계는 실습용이며 공식 온도 등급이 아니다.
# right = TRUE이면 오른쪽 경계를 포함한다: (70, 80]은 70 초과, 80 이하이다.
# include.lowest = TRUE로 첫 구간의 최솟값 50도 포함한다.
breaks <- c(50, 70, 80, 100)
bin_labels <- c("낮음", "중간", "높음")

# 작은 예제: 70은 첫 구간 [50, 70]에, 71은 둘째 구간 (70, 80]에 속한다.
print(cut(c(70, 71), breaks = breaks, labels = bin_labels,
          right = TRUE, include.lowest = TRUE))

# 실행 전 예상: 80은 중간/높음 중 어디에 속하는가? 81은 어디에 속하는가?
boundary_values <- c(70, 80, 81)
cat("경계 근처 값의 구간:\n")
print(cut(boundary_values, breaks = breaks, labels = bin_labels,
          right = TRUE, include.lowest = TRUE))
# 차례로 낮음, 중간, 높음이다. 80은 둘째 구간의 오른쪽 경계에 포함된다.

temp_bins <- cut(airquality$Temp, breaks = breaks, labels = bin_labels,
                 right = TRUE, include.lowest = TRUE)
cat("처음 여섯 온도와 범주:\n")
print(data.frame(Temp = head(airquality$Temp), bin = head(temp_bins)))
cat("범주별 관측 개수:\n")
print(summary(temp_bins))
# cut() 결과는 factor이므로 summary()는 각 범주의 관측 개수를 보여 준다.
# 원래 온도와 범주를 나란히 보고, 각 값이 지정한 경계에 맞게 들어갔는지 확인한다.

# 5. 결과 해석 ----------------------------------------------------
# - 결측값: is.na()의 TRUE 개수와 평균에 실제 사용된 값의 수를 읽는다.
# - 이상치 후보: Q1/Q3 → IQR → 경계 → 경계 밖의 관측값을 순서대로 읽는다.
# - 구간화: 경계의 포함 방향을 먼저 확인한 뒤 온도와 범주를 대응시킨다.
# 결측값 처리, 이상치 후보 판정, 구간화는 서로 다른 데이터 처리이다.
# na.rm은 결측값만 계산에서 제외하며 이상치 후보를 찾아 제외하지 않는다.

# 6. 하나 바꿔보기 ------------------------------------------------
# 같은 값과 경계를 두고 right만 FALSE로 바꾼다.
# 이번에는 왼쪽 경계를 포함한다: [70, 80)은 70 이상, 80 미만이다.
# 예상: 70과 80의 범주는 각각 어디로 바뀌는가? 81의 범주는 유지되는가?
print(cut(boundary_values, breaks = breaks, labels = bin_labels,
          right = FALSE, include.lowest = TRUE))
# 중간, 높음, 높음이다. 경계값 70과 80의 소속이 바뀌고 81은 그대로이다.

# 7. 시험 체크 ----------------------------------------------------
# 1) NA와 숫자 0은 같은 의미인가?
# 2) mean(c(2, NA, 4), na.rm = TRUE)의 값과 평균 계산의 분모는?
# 3) Q1 = 12, Q3 = 16일 때 값 22와 40 중 1.5 × IQR 규칙의 후보는?
#    그 후보를 반드시 삭제해야 하는가?
# 4) right = TRUE인 구간 (70, 80]에서 값 80은 포함되는가?

# 정답 및 해설 ----------------------------------------------------
# 1) 아니다. NA는 알려지지 않은 값, 0은 관측된 숫자 값이다.
# 2) 평균 3, 분모 2. NA를 0으로 바꾼 뒤 3개로 나누는 계산이 아니다.
# 3) 상한이 22이므로 22는 후보가 아니고 40은 후보이다.
#    후보는 원인과 맥락을 확인해야 하며 자동 삭제의 근거가 아니다.
# 4) 포함된다. 오른쪽 경계 80은 포함하고 왼쪽 경계 70은 제외한다.
