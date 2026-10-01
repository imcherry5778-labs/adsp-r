# Lab 08 — MDS와 PCA의 목적과 출력 읽기 (약 25분)
# 이 파일만 위에서 아래로 실행하면 된다. USArrests는 R의 내장 자료이다.

# 1. 목표 --------------------------------------------------------
# - MDS의 거리 표현과 PCA의 분산 중심 축 구성을 구분한다.
# - PCA의 설명분산 비율·누적 비율과 loading을 읽는다.
# - 변수의 단위와 변동 규모가 다를 때 scaling의 영향을 확인한다.

# 2. 핵심 개념과 작은 예제 ----------------------------------------
# USArrests의 행은 미국 50개 주, 열은 네 변수이다.
# Murder, Assault, Rape는 인구 10만 명당 해당 범죄의 체포 건수,
# UrbanPop은 도시 인구 비율(%)이다. 열마다 단위와 변동 규모가 다르다.
cat("처음 세 주의 원자료:\n")
print(USArrests[1:3, ])
# 행 하나가 관측치이다. Assault의 숫자가 크다고 분석에 더 중요한 변수는 아니다.

# MDS: 관측치 사이의 거리/비유사성 관계를 저차원 좌표로 표현한다.
# 여기서는 dist()의 기본 유클리드 거리와 고전적 MDS인 cmdscale()을 사용한다.
# PCA: 원래 변수들의 선형결합으로 새로운 축인 principal component(PC)를 만든다.
# PC1은 분산을 가장 많이 담고, PC2는 PC1과 직교하며 남은 분산을 가장 많이 담는다.
# 둘 다 차원을 줄이지만 MDS는 거리 관계, PCA는 분산을 담는 축에 초점을 둔다.

# scale()의 기본값은 각 열에서 평균을 빼고 표준편차로 나누는 표준화이다.
# 표준화 값 1은 그 변수의 평균보다 표준편차 하나만큼 높다는 뜻이다.
# 표준화는 변수를 모두 같은 단위 없는 척도로 비교하게 한다.

# 3. 먼저 예상하기 -----------------------------------------------
# 예상 1: 네 변수의 단위를 그대로 쓰면 변동 규모가 큰 Assault가
#         거리와 PCA에 더 큰 영향을 줄 수 있을까?
# 예상 2: 네 변수로 만든 2차원 MDS에서 모든 원래 거리가 정확히 보존될까?
# 예상 3: PCA에서 PC1의 설명분산 비율이 0.62, PC2가 0.25라면
#         두 축의 누적 비율은 얼마인가? PC1은 원래 변수 하나인가?

# 4. 직접 실행 ----------------------------------------------------
# 실험 A: MDS와 PCA에 사용할 공통 표준화 자료를 준비한다.
arrests_scaled <- scale(USArrests)
cat("각 변수의 표준화 전후 표준편차:\n")
print(round(data.frame(raw_sd = apply(USArrests, 2, sd),
                       scaled_sd = apply(arrests_scaled, 2, sd)), 3))
# raw_sd에서 Assault 약 83.34와 Murder 약 4.36을 비교한다.
# scaled_sd는 모두 1이다. 표준편차를 맞춘 것이며, 변수들이 서로 같은 값이 되거나 똑같이 중요한 변수가 되는 것은 아니다.

# 실험 B: 거리를 먼저 만든 뒤 MDS 좌표를 얻는다.
original_dist <- dist(arrests_scaled)
mds_points <- cmdscale(original_dist, k = 2)
colnames(mds_points) <- c("MDS1", "MDS2")
cat("처음 다섯 주의 2차원 MDS 좌표:\n")
print(round(mds_points[1:5, ], 3))
# 두 열은 저차원 공간의 좌표이다. 원래의 Murder·Assault 값이나 확률이 아니다.
# 축의 양수/음수 자체보다 두 주의 점이 얼마나 떨어져 있는지를 본다.

# 처음 세 주의 세 쌍만 골라 원래 거리와 2차원 표현의 거리를 비교한다.
mds_dist <- dist(mds_points)
state_pairs <- rbind(c("Alabama", "Alaska"),
                     c("Alabama", "Arizona"),
                     c("Alaska", "Arizona"))
cat("표준화 자료의 거리와 MDS 그림의 거리:\n")
print(data.frame(pair = paste(state_pairs[, 1], state_pairs[, 2], sep = " / "),
                 original = round(as.matrix(original_dist)[state_pairs], 3),
                 MDS_2D = round(as.matrix(mds_dist)[state_pairs], 3)))
# original은 네 변수로 계산한 거리, MDS_2D는 두 좌표로 계산한 거리이다.
# 값이 가까운지 비교한다. 차원을 줄였으므로 모든 쌍의 거리가 정확히 같지는 않다.
# 첫 쌍은 약 2.70에서 0.96으로 크게 줄었다. 그림에서 가까워 보여도
# 원래 네 변수의 차이가 모두 보존된 것은 아니다.
# 고전적 MDS는 원래 거리 관계를 가능한 한 비슷하게 표현한다.

# 겹치는 이름을 모두 붙이지 않고 처음 세 주만 표시한다.
plot(mds_points, pch = 19, col = "gray50", asp = 1,
     main = "MDS: standardized USArrests", xlab = "MDS1", ylab = "MDS2")
text(mds_points[1:3, ], labels = rownames(USArrests)[1:3], pos = 3, cex = 0.8)
# 가까운 점은 이 2차원 표현에서 서로 비슷하게 놓인 주이다.
# 원래 네 변수의 차이까지 작은지는 앞의 거리 비교도 함께 확인한다.
# 이 거리는 지리적 거리도, 두 주가 같은 집단임을 확정하는 기준도 아니다.

# 실험 C: 동일한 표준화 자료로 PCA의 축과 설명분산을 읽는다.
# 이미 평균 0·표준편차 1로 만들었으므로 다시 중심화하거나 표준화하지 않는다.
pca_scaled <- prcomp(arrests_scaled, center = FALSE, scale. = FALSE)
cat("표준화 자료의 PCA 요약:\n")
print(summary(pca_scaled))
# Proportion of Variance 행: 각 PC가 전체 분산 중 설명하는 비율이다.
# PC1 약 0.620, PC2 약 0.247을 찾는다.
# Cumulative Proportion 행: PC1부터 해당 PC까지 합한 비율이다.
# PC2 열의 약 0.868은 두 축이 전체 분산의 약 86.8%를 담는다는 뜻이다.
# 분류 정확도도, 거리의 86.8%가 정확히 보존되었다는 뜻도 아니다.

cat("PC1·PC2의 loading:\n")
print(round(pca_scaled$rotation[, 1:2], 3))
# rotation의 행은 원래 변수, 열은 PC이다. 각 값은 축을 만드는 계수(loading)이다.
# 예를 들어 PC1 점수는 네 표준화 변수에 PC1 열의 계수를 곱해 더한 값이다.
# 따라서 PC1은 Murder 자체가 아니라 원래 변수들의 조합이다.
# PC1에서는 세 범죄 변수의 loading 절댓값이 UrbanPop보다 크다.
# PC2에서는 UrbanPop의 절댓값이 가장 크다. 표준화된 변수끼리 상대 크기를 읽는다.
# 같은 PC 열 안의 같은/반대 부호는 그 축에 기여하는 방향의 관계를 나타낸다.
# 한 PC의 loading과 점수 부호를 모두 뒤집어도 같은 해를 표현한다.
# 'PC1의 음수는 언제나 나쁘다'처럼 부호 자체에 절대 의미를 붙이지 않는다.

cat("처음 세 주의 PC 점수:\n")
print(round(pca_scaled$x[1:3, 1:2], 3))
# x의 행은 주, 열은 새 축의 좌표(점수)이다. rotation의 변수별 계수와 구분한다.
plot(pca_scaled$x[, 1:2], pch = 19, col = "gray50", asp = 1,
     main = "PCA: standardized USArrests", xlab = "PC1", ylab = "PC2")
text(pca_scaled$x[1:3, 1:2], labels = rownames(USArrests)[1:3], pos = 3, cex = 0.8)
# 두 그림에서 주들의 상대적 배치를 비교한다. 축 방향이 뒤집혀 보일 수 있다.
# 이번처럼 유클리드 거리를 쓰는 고전적 MDS와 같은 자료의 PCA는
# 같은 점 사이 거리 배치를 얻을 수 있다. 이 특수한 관계가 MDS와 PCA가 일반적으로 같은 방법이라는 뜻은 아니다.
# 그림이 닮아도 설명하는 목적을 구분한다.

# 5. 결과 해석 ----------------------------------------------------
# MDS의 두 좌표는 '어떤 주끼리 가까운가'를 거리 관계로 읽는다.
# PCA의 summary는 '몇 개 축으로 분산을 얼마나 담았는가'를 읽는다.
# rotation은 '그 축이 어떤 변수 조합인가', x는 '각 주가 그 축의 어디에 있는가'이다.
# 두 분석 모두 여기서는 정답 범주를 예측하는 지도학습 분류가 아니다.

# 6. 하나 바꿔보기 ------------------------------------------------
# PCA에서 scaling만 제거한다. 자료와 중심화는 유지한다.
# 예상: 표준편차가 컸던 Assault의 PC1 loading 절댓값이 더 두드러질까?
#       PC1의 설명분산 비율이 높아지면 무조건 더 좋은 분석인가?
pca_raw <- prcomp(USArrests, center = TRUE, scale. = FALSE)
cat("scaling 전후 PC1의 loading 절댓값:\n")
print(round(data.frame(without_scaling = abs(pca_raw$rotation[, 1]),
                       with_scaling = abs(pca_scaled$rotation[, 1])), 3))
# scaling 전에는 Assault 약 0.995가 두드러진다. 변동 규모의 영향을 크게 받는다.
# scaling 후에는 세 범죄 변수의 크기가 서로 가까워진다.
# 서로 다른 척도에서 얻은 loading이므로 같은 단위의 효과 크기로 비교하지 않는다.

cat("scaling 전후 PC1의 설명분산 비율:\n")
print(round(c(without_scaling = pca_raw$sdev[1]^2 / sum(pca_raw$sdev^2),
              with_scaling = pca_scaled$sdev[1]^2 / sum(pca_scaled$sdev^2)), 3))
# 약 0.966 → 0.620이다. scaling으로 '전체 분산'의 기준 자체가 달라졌다.
# 높은 비율만으로 우열을 정하지 않는다. 원래 단위의 차이를 반영할지 먼저 판단한다.
# 표준화는 단위·크기의 지배를 줄이지만 언제나 최선인 것은 아니다.

# 7. 시험 체크 ----------------------------------------------------
# 1) MDS와 PCA는 저차원 표현에서 각각 무엇에 초점을 두는가?
# 2) summary의 PC1 비율 0.6201, PC2 비율 0.2474와 PC2 누적 비율은 어떻게 다른가?
# 3) rotation과 x는 각각 무엇을 담는가? PC1은 원래 변수 하나인가?
# 4) 한 PC의 모든 loading과 점수 부호가 함께 뒤집히면 다른 해인가?
# 5) USArrests에서 scaling을 하는 이유는? 설명분산 비율이 높으면 항상 더 좋은가?

# 정답 및 해설 ----------------------------------------------------
# 1) MDS는 관측치 사이 거리/비유사성 관계, PCA는 분산을 잘 담는 새 축 구성이다.
# 2) 앞의 두 값은 각 축의 비율, 누적 비율은 합인 0.8675(약 86.8%)이다.
# 3) rotation은 변수별 loading, x는 관측치별 PC 점수이다. PC1은 변수들의 선형결합이다.
# 4) 아니다. 축 방향만 바뀌며 설명분산과 점 사이 거리는 같다.
# 5) 단위·변동 규모가 분석을 지배하는 것을 줄이기 위해서이다.
#    scaling 전후에는 분산의 기준이 다르므로 높은 비율만으로 우열을 정할 수 없다.
