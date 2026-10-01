# Lab 02 — 조건 선택, 병합, 반복 요약 (약 25분)
# 이 파일만 위에서 아래로 실행하면 된다. 패키지를 추가로 설치하지 않는다.

# 1. 목표 --------------------------------------------------------
# - 조건의 TRUE/FALSE 결과로 행을 선택한다.
# - 공통 키로 표를 병합하고 일치하지 않는 행의 처리를 읽는다.
# - apply 계열의 적용 대상과 반환 형태, 데이터 조작 용어를 구분한다.

# 2. 핵심 개념과 작은 예제 ----------------------------------------
# []로 위치를 고르는 대신 논리값으로도 고를 수 있다.
# TRUE인 위치를 남기고 FALSE인 위치는 제외한다.
small_scores <- c(70, 90)
print(small_scores >= 80)
print(small_scores[small_scores >= 80])
# FALSE, TRUE이므로 두 번째 점수 90만 선택된다.
# 표의 행 선택도 같은 원리이며, [행 조건, ]처럼 열 위치를 비워 모든 열을 남긴다.

# 3. 먼저 예상하기 -----------------------------------------------
# 학습자 id 1, 2, 3, 4의 점수가 차례로 70, 90, 60, 80이다.
# 예상 1: 점수 >= 80 조건의 논리값 네 개와 남을 id 두 개는?
# 별도 수강 정보에는 id 1, 2, 4, 5만 있다.
# 예상 2: 두 표에 공통으로 있는 id만 병합하면 몇 행이 남는가?
# 예상 3: 집단별 평균 하나씩을 구할 때 lapply()와 sapply() 중
#         결과를 list로 유지하는 함수는 무엇인가?

# 4. 직접 실행 ----------------------------------------------------
students <- data.frame(
  id = c(1, 2, 3, 4),
  group = c("A", "A", "B", "B"),
  score = c(70, 90, 60, 80),
  practice = c(80, 100, 70, 90)
)

# 실험 A: 먼저 조건 결과를 본 뒤, 그 조건으로 행을 선택한다.
threshold <- 80
keep <- students$score >= threshold
cat("행별 조건 결과:\n")
print(keep)
cat("조건을 만족하는 행:\n")
print(students[keep, ])
cat("subset()으로 같은 행 선택:\n")
print(subset(students, score >= threshold))
# FALSE, TRUE, FALSE, TRUE를 원자료 행 순서에 대응시킨다.
# 두 방법 모두 id 2와 4를 남긴다. subset() 안에서는 열 이름을 바로 쓸 수 있다.

# 실험 B: 행의 위치가 아니라 공통 키 id로 수강 정보를 붙인다.
course_info <- data.frame(
  id = c(1, 2, 4, 5),
  course = c("통계", "통계", "R", "R")
)
cat("공통 id만 병합:\n")
matched <- merge(students, course_info, by = "id")
print(matched)
# 기본 merge() 결과는 양쪽에 있는 id 1, 2, 4의 세 행이다.
# students에만 있는 id 3, course_info에만 있는 id 5는 제외된다.

# all.x = TRUE로 첫 번째 표의 모든 id를 유지하는 경우와 비교한다.
cat("students의 모든 id를 유지해 병합:\n")
with_all_students <- merge(students, course_info, by = "id", all.x = TRUE)
print(with_all_students)
# id 3도 남지만 course는 NA이다. 대응하는 수강 정보가 없기 때문이다.
# NA는 값이 없음을 뜻한다. 구체적인 결측값 처리는 다음 Lab에서 살펴본다.
# 병합 출력에서는 id와 새로 붙은 course를 함께 읽어 대응이 맞는지 확인한다.

# 실험 C: apply()는 행 또는 열에 함수를 적용한다.
# 숫자 열만 골라 행렬로 바꾼다. 문자 열을 함께 넣지 않는다.
score_matrix <- as.matrix(students[, c("score", "practice")])
print(score_matrix)
cat("행별 평균 (MARGIN = 1):\n")
print(apply(score_matrix, MARGIN = 1, FUN = mean))
cat("열별 평균 (MARGIN = 2):\n")
print(apply(score_matrix, MARGIN = 2, FUN = mean))
# 행별 첫 값 75는 id 1의 두 점수 (70 + 80) / 2이다.
# 열별 score의 75와 practice의 85는 각각 네 학습자의 평균이다.
# 같은 mean()이어도 행에 적용하는지 열에 적용하는지에 따라 의미가 다르다.

# 실험 D: 집단으로 나누고, 같은 계산을 적용하고, 결과를 모은다.
# split-apply-combine은 '분할 → 적용 → 결합'의 흐름을 뜻한다.
group_scores <- split(students$score, students$group)
cat("집단별로 분할한 점수:\n")
print(group_scores)
cat("lapply()로 집단별 평균:\n")
means_list <- lapply(group_scores, mean)
print(means_list)
cat("sapply()로 집단별 평균:\n")
means_vector <- sapply(group_scores, mean)
print(means_vector)
print(class(means_list))
print(class(means_vector))
# A의 평균은 (70 + 90) / 2 = 80, B의 평균은 (60 + 80) / 2 = 70이다.
# lapply()는 결과를 list로 유지한다.
# sapply()는 이처럼 원소별 결과가 숫자 하나씩이면 숫자 벡터로 단순화한다.
# sapply()가 항상 벡터를 반환하는 것은 아니다. 결과 구성에 따라 달라진다.

# 5. 결과 해석 ----------------------------------------------------
# 조건 선택: 논리값의 순서 → 선택된 id를 확인한다.
# 병합: 공통 키 → 남거나 제외된 id → 대응 정보가 없는 NA를 확인한다.
# 반복 요약: 적용 대상(행/열/집단) → 계산값 → 반환 형태를 확인한다.

# ADsP 데이터 조작 용어는 목적 수준에서 구분한다. 여기서는 실행하지 않는다.
# - reshape: 데이터를 긴 형태/넓은 형태 등으로 재구성한다.
# - plyr: 분할-적용-결합 방식의 데이터 처리를 지원한다.
# - sqldf: R의 data.frame을 SQL 질의로 다룬다.
# - data.table: 표 형태의 데이터를 효율적으로 선택·집계·결합한다.
# 이 용어를 아는 것과 각 패키지의 사용법을 익히는 것은 별개의 목표이다.

# 6. 하나 바꿔보기 ------------------------------------------------
# 다른 데이터는 유지하고 선택 기준만 80에서 90으로 올린다.
# 예상: id 2와 4 중 어느 id가 제외되는가? 남는 행은 몇 개인가?
threshold <- 90
print(students[students$score >= threshold, ])
# 점수 80인 id 4가 제외되어 점수 90인 id 2 한 행만 남는다.

# 7. 시험 체크 ----------------------------------------------------
# 1) 행 조건이 TRUE, FALSE, TRUE라면 몇 번째 행을 선택하는가?
# 2) 이 실험의 기본 merge()에서 id 3과 5가 제외되는 이유는?
# 3) 원소별 계산 결과를 항상 list로 반환하는 함수는 lapply(), sapply() 중 무엇인가?
# 4) apply()에서 MARGIN = 2는 행별인가, 열별인가?
# 5) data.frame에 SQL 질의를 사용하는 용어는 reshape, sqldf 중 무엇인가?

# 정답 및 해설 ----------------------------------------------------
# 1) 첫 번째와 세 번째 행. TRUE인 위치를 선택한다.
# 2) 한쪽에만 있기 때문이다. 기본 병합은 두 표에서 키가 일치하는 행을 남긴다.
# 3) lapply(). sapply()는 가능한 경우 결과를 벡터나 행렬 등으로 단순화한다.
# 4) 열별. MARGIN = 1은 행별이며, 어느 방향인지에 따라 요약의 의미가 달라진다.
# 5) sqldf. reshape는 데이터의 형태를 재구성하는 용도이다.
