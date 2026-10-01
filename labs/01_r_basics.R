# Lab 01 — 자료구조와 인덱싱 (약 25분)
# 이 파일만 위에서 아래로 실행하면 된다. 이전 Lab의 객체는 필요 없다.

# 1. 목표 --------------------------------------------------------
# - vector, matrix, factor, list, data.frame의 차이를 구분한다.
# - class(), str(), summary()에서 자료의 종류와 구성을 읽는다.
# - 위치를 지정해 값을 꺼내는 인덱싱 결과를 예측한다.

# 2. 핵심 개념과 작은 예제 ----------------------------------------
# <-로 저장한 객체는 자료구조에 따라 값을 담는 방식이 다르다.
# vector는 한 자료형의 값들을 나열한다. R의 위치 번호는 1부터 시작한다.
scores <- c(60, 80, 100)
print(scores)
print(scores[2])
# 두 번째 위치의 값은 80이다. [] 안의 숫자는 꺼낼 위치이다.

# 이번 Lab에서 구분할 자료구조:
# - matrix: 행과 열이 있으며, 모든 원소가 같은 자료형이다.
# - data.frame: 표이며, 열마다 서로 다른 자료형을 담을 수 있다.
# - factor: 범주 값과 가능한 범주의 목록(levels)을 함께 담는다.
# - list: 서로 다른 종류나 길이의 객체를 원소로 담을 수 있다.

# 3. 먼저 예상하기 -----------------------------------------------
# 예상 1: scores[c(1, 3)]은 어떤 두 값을 꺼내는가?
# 예상 2: 이름과 점수를 함께 넣은 matrix의 점수는 숫자로 남을까?
#         같은 정보를 data.frame에 담으면 점수 열은 어떤 자료형일까?
# 예상 3: "불합격", "합격", "합격"을 factor로 만들었을 때
#         summary()에 표시될 각 범주의 개수는 얼마일까?

# 4. 직접 실행 ----------------------------------------------------
# 실험 A: 같은 객체를 세 가지 관점에서 살펴본다.
cat("벡터의 종류, 내부 구성, 요약:\n")
print(class(scores))
str(scores)
print(summary(scores))
print(scores[c(1, 3)])
# class(): numeric이라는 자료의 종류를 확인한다.
# str(): num [1:3]에서 숫자형이고 값이 3개임을 읽는다.
# summary(): 숫자 자료의 최솟값, 중앙값, 평균 등의 요약을 보여 준다.
# 선택 결과 60, 100은 요약이 아니라 지정한 위치의 원래 값이다.

# 실험 B: matrix와 data.frame에 같은 이름과 점수를 담는다.
# c()로 문자와 숫자를 합치면 한 자료형으로 맞추면서 모두 문자가 된다.
# byrow = TRUE는 값을 행 방향으로 채운다는 뜻이다.
score_matrix <- matrix(c("민수", 70, "지수", 90), nrow = 2, byrow = TRUE)
students <- data.frame(name = c("민수", "지수"), score = c(70, 90))

cat("matrix:\n")
print(score_matrix)
print(class(score_matrix))
str(score_matrix)
cat("data.frame:\n")
print(students)
print(class(students))
str(students)
# matrix의 str()에서 chr는 모든 원소가 문자라는 뜻이다.
# data.frame에서는 name이 chr이고 score는 num이다. 열별 자료형이 유지된다.
# matrix의 class()에 matrix와 array가 함께 나와도 이 객체는 행렬이다.

# [행, 열]로 두 번째 행의 두 번째 열을 꺼낸다.
print(score_matrix[2, 2])
print(students[2, 2])
# "90"의 따옴표는 문자, 90은 숫자이다. 겉으로 같은 값이어도 자료형이 다르다.

# 행 위치를 비우면 모든 행을 선택한다. $score는 이름으로 점수 열을 선택한다.
print(students[, "score"])
print(students$score)
print(summary(students))
# 두 선택 모두 숫자 벡터 70, 90을 반환한다.
# summary(students)는 열마다 요약한다. score에는 숫자 요약이 나타난다.

# 실험 C: 문자 벡터와 factor를 비교한다.
result_text <- c("불합격", "합격", "합격")
result_factor <- factor(result_text, levels = c("불합격", "합격"))
cat("문자 벡터와 factor의 구성:\n")
str(result_text)
str(result_factor)
print(result_factor)
print(class(result_factor))
cat("문자 벡터의 요약:\n")
print(summary(result_text))
cat("factor의 요약:\n")
print(summary(result_factor))
# 문자 벡터의 summary()는 Length, Class, Mode를 보여 준다.
# factor의 summary()는 불합격 1개, 합격 2개라는 범주별 개수를 보여 준다.
# Levels에 나오는 두 이름은 범주 목록이다. 관측값 3개와 구분한다.
# str()의 1, 2, 2는 범주를 가리키는 내부 코드이며 점수나 크기가 아니다.
# 여기서 levels의 순서를 지정했다고 순서형 factor가 되는 것은 아니다.

# 실험 D: list는 하나의 원소에 벡터 전체도 담을 수 있다.
profile <- list(name = "민수", scores = scores)
print(class(profile))
str(profile)
# List of 2는 원소가 두 개라는 뜻이다.
# name은 문자 하나, scores는 숫자 세 개로 원소의 길이와 종류가 다르다.

# 실행 전 예상: [2]와 [[2]] 중 숫자 벡터 자체를 꺼내는 것은 무엇인가?
print(profile[2])
print(profile[[2]])
print(class(profile[2]))
print(class(profile[[2]]))
# [2]는 두 번째 원소를 담은 list, [[2]]는 그 안의 숫자 벡터를 반환한다.

# 5. 결과 해석 ----------------------------------------------------
# 출력에서 읽을 순서:
# - class(): 어떤 자료구조인가? 예: data.frame, factor, list.
# - str(): 안에는 무엇이 몇 개 있는가? 예: 열별 chr/num, factor의 범주 수.
# - summary(): 그 종류에 맞는 요약은 무엇인가? 예: 숫자 요약, 범주별 개수.
# ADsP 자료구조 구분에서는 표처럼 보이는지만 판단하지 않는다.
# matrix의 단일 자료형과 data.frame의 열별 자료형 차이를 함께 확인한다.

# 6. 하나 바꿔보기 ------------------------------------------------
# factor의 levels는 유지하고 관측값 하나만 불합격으로 바꾼다.
# 예상: 범주 수는 2로 유지될까? 불합격과 합격의 개수는 각각 얼마일까?
result_factor[3] <- "불합격"
print(result_factor)
print(summary(result_factor))
# 범주 목록은 그대로 두 개이다. 관측 개수는 불합격 2개, 합격 1개가 된다.

# 7. 시험 체크 ----------------------------------------------------
# 1) 문자 이름과 숫자 점수의 자료형을 열별로 유지할 구조는?
# 2) factor의 levels가 2개이고 관측값이 10개라면 범주 수는?
# 3) students[1, 2]는 어느 위치의 값이며, 결과는 얼마인가?
# 4) 객체의 내부 구성과 자료형을 간단히 확인할 함수는?
# 5) profile에서 두 번째 원소 안의 숫자 벡터를 꺼낼 표현은?

# 정답 및 해설 ----------------------------------------------------
# 1) data.frame. matrix는 모든 원소가 같은 자료형이다.
# 2) 2개. levels는 범주 목록이며 관측값의 개수와 다르다.
# 3) 첫 번째 행, 두 번째 열의 숫자 70이다. 행 번호가 먼저 온다.
# 4) str(). class()는 종류, summary()는 종류에 맞는 요약을 보여 준다.
# 5) profile[[2]]. profile[2]는 원소 하나를 담은 list이다.
