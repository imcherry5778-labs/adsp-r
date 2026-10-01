# Lab 12 — 정답 label 없이 군집 만들고 읽기 (약 25분)
# 이 파일만 위에서 아래로 실행하면 된다. iris는 R의 내장 자료이다.

# 1. 목표 --------------------------------------------------------
# - classification과 clustering을 정답 label 사용 여부로 구분한다.
# - hierarchical clustering의 dendrogram과 k-means의 배정·중심·크기를 읽는다.
# - k-means, DBSCAN, SOM의 핵심 차이를 설명한다.

# 2. 핵심 개념과 작은 예제 ----------------------------------------
# Lab 09~10의 classification은 정답 label을 사용해 예측 규칙을 학습했다.
# clustering은 정답 label 없이 관측치의 비슷한 구조를 찾는 비지도학습이다.
# 이번 입력은 꽃받침·꽃잎의 길이와 너비 네 변수이며 Species는 제외한다.
iris_numeric <- iris[, c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width")]
cat("군집 입력의 처음 세 꽃: 네 수치 변수만 확인하세요.\n")
print(iris_numeric[1:3, ])
# 행 하나는 꽃 한 개, 열 하나는 측정 변수이다. 품종을 예측하는 학습이 아니다.

# 거리 기반 방법은 변수의 척도·변동 크기에 영향을 받을 수 있다.
# 여기서는 scale()로 각 변수의 평균을 빼고 표준편차로 나누어 비교한다.
# 언제나 표준화해야 한다는 규칙은 아니다. 여기서는 변동 크기를 맞추는 선택이다.
# 작은 거리 예: 표준화한 네 변수의 차이가 (1, 0, 0, 0)이면 유클리드 거리는 1이다.
# 차이가 모두 0이면 거리도 0이다. 값의 차이가 거리 계산의 출발점이다.

# 3. 먼저 예상하기 -----------------------------------------------
# 예상 1: Species를 입력하지 않고 군집을 만들면 지도학습인가, 비지도학습인가?
# 예상 2: dendrogram에서 height 0.5와 2에 합쳐진 두 경우 중,
#         어느 쪽이 더 큰 비유사성 수준에서 합쳐진 것일까?
# 예상 3: K = 3이면 배정 번호는 몇 가지인가? 1이 2보다 낮은 등급일까?

# 4. 직접 실행 ----------------------------------------------------
# 실험 A: 같은 표준화 자료를 두 군집 방법에 사용한다.
iris_scaled <- scale(iris_numeric)
distances <- dist(iris_scaled)
cat("처음 세 꽃 사이의 거리: 행과 열의 관측 번호를 맞춰 읽으세요.\n")
print(round(as.matrix(distances)[1:3, 1:3], 3))
# dist()의 기본값은 유클리드 거리이다. 대각선은 자기 자신이므로 0이다.
# 1-2와 2-1의 값은 같다. 이 숫자는 품종 번호나 예측확률이 아니다.

# 실험 B: 거리 → 단계적 병합 → dendrogram.
hierarchical <- hclust(distances, method = "average")
plot(hierarchical, labels = FALSE, hang = -1,
     main = "iris: hclust (average)", xlab = "", sub = "", ylab = "Height")
# 아래 끝의 가지 하나가 꽃 하나이다. 150개 이름은 겹치므로 표시하지 않았다.
# 처음에는 각 관측이 따로 있고, 가까운 cluster들이 단계적으로 합쳐진다.
# 가로 연결선의 Height를 읽는다. 이 average 방법에서는 합쳐지는
# 두 cluster 사이 모든 관측 쌍의 거리 평균이 해당 height이다.
# 높은 곳에서 합쳐질수록 더 큰 비유사성 수준의 병합이다.
# 좌우 배치 자체는 품종 순서나 좋고 나쁨의 순위가 아니다.

# cutree()는 완성된 계층 구조를 K개로 잘라 관측별 배정을 꺼내는 보조 함수이다.
hierarchical_groups <- cutree(hierarchical, k = 3)
cat("계층 구조를 세 군집으로 잘랐을 때의 관측 수:\n")
print(table(hierarchical_groups))
# 여기서는 이미 만든 계층 구조를 자른 것이다. 세 중심을 새로 학습한 것이 아니다.

# 실험 C: k-means는 K개 중심(centroid)을 기준으로 관측을 나누는 partition 방식이다.
# K = 3은 학습용 비교를 위한 선택이다. 일반적으로 분석자가 정하거나 별도로 판단한다.
# 알고리즘이 Species를 보고 K를 알아낸 것이 아니다.
# nstart = 25는 초기 중심을 여러 번 시도해 초기값에 따른 우연을 줄인다.
set.seed(42)
km_three <- kmeans(iris_scaled, centers = 3, nstart = 25)
selected_rows <- c(1, 2, 51, 52, 101, 102)
cat("여섯 꽃의 cluster 배정: 관측 번호와 배정 번호를 구분하세요.\n")
print(data.frame(observation = selected_rows, cluster = km_three$cluster[selected_rows]))
# cluster에는 150개 꽃 각각의 배정 번호가 들어 있다. 위에는 여섯 개만 표시했다.
# 1, 2, 3은 단순 label이다. 크기·등급·실제 품종 번호를 뜻하지 않는다.
# 실행조건에 따라 군집 번호 자체가 바뀔 수 있다.

cat("centers: 행 = 군집, 열 = 네 표준화 변수:\n")
print(round(km_three$centers, 2))
# 각 행은 그 군집에 속한 관측들의 변수별 평균, 즉 중심이다.
# Petal.Length 열이 양수인 중심은 원자료 전체 평균보다 꽃잎 길이가 긴 쪽이다.
# 음수는 전체 평균보다 짧은 쪽이다. 표준화 값이므로 원래 cm 값과 구분한다.

cat("size: 각 군집의 관측 수(centers와 같은 번호 순서):\n")
print(km_three$size)
# 세 수를 더하면 iris의 150개 관측이다. size는 중심값이 아니라 관측 수이다.

# 실험 D: 군집이 완성된 뒤에만 기존 품종과 대응을 관찰한다.
cat("군집과 품종의 사후 비교: 행 = cluster, 열 = Species:\n")
print(table(cluster = km_three$cluster, Species = iris$Species))
# 행마다 어떤 품종이 많이 모였는지, 한 품종이 여러 행에 나뉘었는지 본다.
# Species는 군집 입력에 쓰지 않았다. 실제 품종을 알고 학습한 결과가 아니다.
# 군집 번호와 품종 번호를 맞춰 정답률을 계산하는 표가 아니다.

# 5. 결과 해석 ----------------------------------------------------
# hierarchical clustering은 단계적 병합 구조를 dendrogram으로 읽는다.
# k-means는 지정한 K에 따른 관측 배정, 중심, 크기를 읽는다.
# 같은 자료를 써도 두 방법이 같은 군집을 만들 필요는 없다.

# 다른 방법은 개념만 비교한다. 패키지를 설치하거나 실행하지 않는다.
# DBSCAN은 밀도가 높은 영역을 군집으로 보고 일부 관측을 noise로 둘 수 있다.
# K를 미리 지정하는 k-means와 달리 거리 반경·최소 관측 수 같은 밀도 관련
# parameter가 필요하다. 군집 수를 지정하지 않아도 설정 선택은 필요하다.
# SOM은 label 없이 경쟁학습을 하는 map이다. 입력에 가장 잘 맞는 winner와
# 그 주변 node를 함께 조정해 비슷한 입력이 가까운 map 영역에 놓이도록 한다.
# winner 하나만 조정하는 방식과 구분한다. 이번에는 map 학습을 구현하지 않는다.

# 6. 하나 바꿔보기 ------------------------------------------------
# 입력·표준화·seed·nstart를 유지하고 k-means의 K만 3 → 2로 바꾼다.
# 예상: 배정 번호와 중심 행은 몇 개가 될까? 기존 세 군집을 그대로 자르는 것일까?
set.seed(42)
km_two <- kmeans(iris_scaled, centers = 2, nstart = 25)
cat("K = 2의 군집별 관측 수:\n")
print(km_two$size)
cat("K = 2의 중심: 앞의 K = 3 중심과 비교하세요.\n")
print(round(km_two$centers, 2))
# 중심은 두 행, 배정 번호는 두 가지이며 관측 수의 합은 여전히 150이다.
# 두 중심을 다시 구한 것이다. hierarchical의 dendrogram을 자른 것과 다르다.
# K가 달라져도 품종이 두 종류로 변한 것은 아니다. 찾으려는 군집 수를 바꾼 것이다.
# 두 실행의 같은 번호를 같은 군집으로 간주하지 말고 중심과 크기를 읽는다.

# 7. 시험 체크 ----------------------------------------------------
# 1) classification과 clustering의 핵심 차이는? 이번 Species는 언제 사용했는가?
# 2) dendrogram의 height와 좌우 위치는 각각 어떻게 읽는가?
# 3) k-means의 K, cluster, centers, size는 무엇인가? cluster 1은 첫 품종인가?
# 4) DBSCAN은 K를 미리 지정해야 하는가? 어떤 설정이 필요하고 noise는 가능한가?
# 5) SOM에서 winner와 주변 node를 함께 조정하는 목적은 무엇인가?

# 정답 및 해설 ----------------------------------------------------
# 1) classification은 정답 label로 예측 규칙을 학습하고 clustering은 label 없이
#    구조를 찾는다. Species는 군집 완성 뒤 table() 비교에만 사용했다.
# 2) height는 해당 방법에서 합쳐지는 비유사성/기준 수준이다.
#    여기서는 cluster 간 평균 거리이다. 좌우 위치 자체에는 순위 의미가 없다.
# 3) K는 지정한 군집 수, cluster는 관측별 배정, centers는 변수별 군집 중심,
#    size는 군집별 관측 수이다. 번호는 label이며 품종 번호와 같지 않다.
# 4) K를 미리 지정하는 방식이 아니다. 밀도 관련 parameter가 필요하며 noise도 가능하다.
# 5) 경쟁학습에서 비슷한 입력이 가까운 map 영역에 놓이도록 하기 위해서이다.
