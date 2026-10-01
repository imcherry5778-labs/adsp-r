# Lab 07 — 추세·계절성과 ACF/PACF 읽기 (약 30분)
# 이 파일만 위에서 아래로 실행하면 된다. 내장 자료와 재현 가능한 모의자료를 사용한다.

# 1. 목표 --------------------------------------------------------
# - 시계열 그림과 분해 결과에서 추세·계절성·불규칙 성분을 구분한다.
# - 정상 AR/MA 모의자료의 ACF/PACF를 읽고 절단 패턴의 범위를 설명한다.
# - AR, MA, ARMA를 구분하고 ARIMA에서 차분이 필요한 이유를 말한다.

# 2. 핵심 개념과 작은 예제 ----------------------------------------
# 시계열은 시간 순서가 있는 자료이다. 앞뒤 관측의 관계를 살펴본다.
# 추세(trend)는 장기적인 상승·하락, 계절성(seasonality)은 일정 주기의 반복이다.
# 불규칙 성분은 추세·계절성으로 설명되지 않는 나머지이다.
# AirPassengers는 1949~1960년의 월별 항공 승객 수(천 명 단위)이다.
cat("첫 1년의 월별 승객 수:\n")
print(head(AirPassengers, 12))
cat("한 해의 관측 수:\n")
print(frequency(AirPassengers))
# 1월 112는 112천 명을 뜻한다. frequency의 12는 월별 관측의 연간 주기이다.
# 첫 1년의 등락만으로 장기 추세를 판단하지 말고 전체 기간을 함께 본다.

# 3. 먼저 예상하기 -----------------------------------------------
# 전체 그림에서 연도가 지날수록 승객 수 수준과 계절 변동폭은 어떻게 변할까?
# 수준의 변화와 반복 등락을 구분해 예상한 뒤 아래 그림을 실행하세요.

# 4. 직접 실행 ----------------------------------------------------
# 실험 A: 원자료를 보고 추세와 계절성을 나누어 관찰한다.
plot(AirPassengers, main = "AirPassengers", xlab = "Year",
     ylab = "Passengers (thousands)")
# 연도가 지날수록 수준이 올라간다: 상승 추세이다.
# 매년 비슷한 시기의 봉우리와 골이 반복된다: 연간 계절성이다.
# 뒤로 갈수록 계절 변동의 절대 크기도 커진다.

# 수준이 높을수록 계절 변동폭이 커져 여기서는 곱셈형 분해를 사용한다.
# 곱셈형: observed = trend × seasonal × random.
# 이 자료는 모두 양수이다. seasonal과 random은 원래 승객 수가 아닌 비율이다.
components <- decompose(AirPassengers, type = "multiplicative")
plot(components)
# 그림의 이름을 원자료와 연결해 읽는다.
# - observed: 실제 월별 관측값. 추세와 계절성이 함께 나타난다.
# - trend: 계절 등락을 완화한 장기 수준. 전체적으로 상승한다.
# - seasonal: 매년 반복되는 월별 비율. 1보다 크면 추세보다 높은 계절 수준이다.
# - random: 추세·계절성을 나누고 남은 비율. 1 근처이면 두 성분으로 잘 설명된다.
# random이라는 이름만으로 이 성분의 독립성이나 정상성이 증명되지는 않는다.

cat("1~12월의 계절 비율:\n")
print(round(setNames(components$seasonal[1:12], paste0(1:12, "월")), 3))
# 1을 기준으로 어느 달이 높고 낮은지 읽는다. 승객 수 자체나 증가 인원이 아니다.
cat("처음 여덟 관측의 분해 성분:\n")
print(data.frame(observed = as.numeric(AirPassengers)[1:8],
                 trend = as.numeric(components$trend)[1:8],
                 seasonal = as.numeric(components$seasonal)[1:8],
                 random = as.numeric(components$random)[1:8]))
# 첫 여섯 trend와 random의 NA는 주변 시점이 부족해 추세를 추정하지 못한 결과이다.
# 원자료의 결측값이 아니다. 계산 가능한 행은 세 성분의 곱이 observed에 대응한다.

# 실험 B: ACF/PACF는 정상 모의자료로 관찰한다.
# 정상성(stationarity)은 평균·분산 같은 성질이 시간에 따라 바뀌지 않는 상태이다.
# AirPassengers는 추세와 변동폭 변화가 있어 원자료에 절단 규칙을 적용하지 않는다.
# ACF: 현재 값과 lag k(시차 k) 전 값의 상관을 보여 준다.
# PACF: 중간 시차의 영향을 제거하고 현재 값과 lag k 전 값의 관계를 보여 준다.
# AR(p): 앞선 p개 관측값의 영향을 포함하는 모형이다.
# MA(q): 현재와 앞선 q개 오차(충격)의 영향을 포함하는 모형이다.
# MA 모형은 관측값 몇 개의 이동평균을 계산하는 연산과 다르다.

# 실행 전 예상: 현재 값이 직전 값에 양의 영향을 받는 AR(1)의 lag 1 상관은 어떤 부호일까?
# AR(1)은 직전 관측값의 영향을, MA(1)은 직전 오차의 영향을 포함한다.
# 두 모형에서 lag 1 뒤 대체로 0이 될 것은 ACF/PACF 중 어느 쪽일지 예상해 보세요.
# 예상이 어려우면 두 그림에서 어느 쪽이 빨리 0 주변으로 가는지 비교하세요.

# arima.sim()으로 정상 순수 AR(1), MA(1)을 각각 400개씩 생성한다.
# AR(1)의 계수 0.7은 정상 범위의 예이다. MA(1)의 오차 계수도 0.7로 둔다.
set.seed(707)
ar_series <- arima.sim(model = list(ar = 0.7), n = 400)
set.seed(708)
ma_series <- arima.sim(model = list(ma = 0.7), n = 400)

# 네 그림을 한 화면에서 비교한 뒤 원래 화면 배치로 돌려놓는다.
plot_settings <- par(mfrow = c(2, 2))
ar_acf <- acf(ar_series, lag.max = 12, main = "AR(1): ACF")
ar_pacf <- pacf(ar_series, lag.max = 12, main = "AR(1): PACF")
ma_acf <- acf(ma_series, lag.max = 12, main = "MA(1): ACF")
ma_pacf <- pacf(ma_series, lag.max = 12, main = "MA(1): PACF")
par(plot_settings)
# 가로축 lag는 시차, 세로축은 상관계수이다. ACF의 lag 0은 자기 자신과의 상관 1이다.
# AR(1): ACF는 점차 감소하고, PACF는 lag 1 뒤 대체로 0 주변이다.
# MA(1): ACF는 lag 1 뒤 대체로 0 주변이고, PACF는 점차 감소한다.
# PACF의 감소는 부호가 번갈아 바뀌면서 절댓값이 작아지는 모양일 수도 있다.

# 그림의 앞 여섯 시차를 숫자로도 확인한다.
# ACF는 lag 0부터, PACF는 lag 1부터 저장되어 꺼내는 위치가 다르다.
cat("시차별 표본 ACF/PACF:\n")
print(round(data.frame(lag = 1:6,
                       AR_ACF = as.numeric(ar_acf$acf)[2:7],
                       AR_PACF = as.numeric(ar_pacf$acf)[1:6],
                       MA_ACF = as.numeric(ma_acf$acf)[2:7],
                       MA_PACF = as.numeric(ma_pacf$acf)[1:6]), 3))
# 절단은 해당 시차 뒤의 상관이 이론적으로 0이라는 뜻이다.
# 표본에서는 정확한 0이 아니며, 일부 막대는 표본 오차로 점선 밖에 나올 수 있다.
# 파란 점선은 상관이 0이라는 가정 아래의 근사 기준이다. 막대 하나로 단정하지 않는다.

# 실험 C: ARIMA의 차분은 시간에 따른 수준 변화를 줄이는 역할을 한다.
# ARMA(p, q)는 AR과 MA를 결합해 정상 시계열을 설명한다.
# ARIMA(p, d, q)의 d는 차분 횟수이다. 차분한 계열에 ARMA를 적용한다.
# d = 0이면 차분하지 않은 ARMA와 같다. 여기서는 모형 적합까지 진행하지 않는다.
# 1차 차분은 '이번 값 - 직전 값'이다. 원래 수준 대신 시점 간 변화를 본다.
passenger_changes <- diff(AirPassengers)
cat("처음 여섯 월간 변화량:\n")
print(head(passenger_changes))
# 첫 값 6은 2월 118 - 1월 112로, 6천 명 증가를 뜻한다.
plot(passenger_changes, main = "diff(AirPassengers)", xlab = "Year",
     ylab = "Change (thousands)")
# 원자료와 비교해 장기 상승 수준은 완화되었지만 반복 등락과 변동폭 변화가 남는다.
# 차분 한 번으로 어떤 자료든 정상 시계열이 되는 것은 아니다.

# 5. 결과 해석 ----------------------------------------------------
# 분해: observed의 모양 → trend의 장기 변화 → seasonal의 반복 → random의 나머지.
# 정상 순수 AR(p): ACF는 절단되지 않고 감쇠(tail off; 경우에 따라 진동), PACF는 p 뒤 절단하는 교과서적 heuristic이다.
# 정상 순수 MA(q): ACF는 q 뒤 절단, PACF는 절단되지 않고 감쇠(tail off)하는 교과서적 heuristic이다.
# 이 규칙은 정상 순수 AR/MA의 이론적 패턴이며 유한 표본에서는 근사적으로 본다.
# ARMA 혼합 모형이나 비정상 원자료에 같은 절단 규칙을 일반화하지 않는다.
# 추세 관찰, 계절성 관찰, ACF/PACF의 시차 관계 해석은 서로 다른 읽기이다.

# 6. 하나 바꿔보기 ------------------------------------------------
# MA(1)의 오차 계수만 0.7에서 -0.7로 바꾼다. 길이는 400으로 유지한다.
# 같은 seed로 난수 조건도 맞춘다. 예상: lag 1 ACF의 부호는 어떻게 바뀔까?
# 계수 부호가 바뀌어도 'MA(1)의 ACF는 lag 1 뒤 절단'이라는 이론적 위치는 같은가?
set.seed(708)
ma_negative <- arima.sim(model = list(ma = -0.7), n = 400)
negative_acf <- acf(ma_negative, lag.max = 12, main = "MA(1), -0.7: ACF")
cat("오차 계수 부호를 바꾼 MA(1)의 lag 1 표본 상관:\n")
print(c(theta_positive = as.numeric(ma_acf$acf)[2],
        theta_negative = as.numeric(negative_acf$acf)[2]))
# lag 1 상관은 양수에서 음수로 바뀐다. 이후 막대는 대체로 0 주변이다.
# 절단 위치는 MA의 차수와 연결되고, 상관의 부호는 계수의 영향을 받는다.

# 7. 시험 체크 ----------------------------------------------------
# 1) 곱셈형 분해에서 trend, seasonal, random은 각각 무엇을 뜻하는가?
# 2) ACF와 PACF는 중간 시차의 영향을 처리하는 방식이 어떻게 다른가?
# 3) 정상 순수 AR(1)에서 lag 1 뒤 이론적으로 절단되는 것은 ACF인가, PACF인가?
# 4) 정상 순수 MA(1)의 ACF는 어느 시차 뒤 절단되는가? 표본에서도 정확히 0인가?
# 5) ARMA와 ARIMA의 차이는 무엇이며, 차분 한 번이면 정상성이 보장되는가?

# 정답 및 해설 ----------------------------------------------------
# 1) trend는 장기 수준, seasonal은 주기적인 계절 비율, random은 설명되지 않은 비율이다.
#    observed = trend × seasonal × random이다. 뒤의 두 성분은 승객 수가 아니다.
# 2) ACF는 시차별 상관, PACF는 중간 시차의 영향을 제거한 상관이다.
# 3) PACF이다. ACF는 점차 감소한다. 정상 순수 AR의 교과서적 규칙이다.
# 4) lag 1 뒤이다. 표본에서는 오차가 있어 정확히 0이 아니며 일부 막대가 튈 수 있다.
# 5) ARMA는 AR과 MA의 결합, ARIMA는 차분 횟수 d를 포함한다(d = 0이면 ARMA).
#    차분은 비정상성을 줄이는 역할이며 한 번의 차분이 정상성을 보장하지 않는다.
