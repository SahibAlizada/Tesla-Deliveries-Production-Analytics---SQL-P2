# Tesla Deliveries & Production Analytics (2015–2025)
***** Məqsəd

Layihənin məqsədi Tesla-nın regional satışlarını, modellər üzrə performansı, qiymət dinamikasını, CO₂ qənaətini, stansiya infrastrukturunun artımını və biznes KPI-lərini SQL vasitəsilə analiz etməkdir.


***** Dataset haqqında

Dataset aşağıdakı sütunlardan ibarətdir:

Year, Month

Region

Model

Estimated_Deliveries

Production_Units

Avg_Price_USD

Battery_Capacity_kWh

Range_km

Charging_Stations

CO2_Saved_tons

***** Analiz Adımları
1. Data Understanding & Basic Checks

Ümumi sətir sayı

Region üzrə observation count

Modellər üzrə minimum, maksimum və orta qiymət

2. Business KPI Analizi
- 1. İl üzrə ümumi Estimated Deliveries

Hər il üçün satış həcmi hesablanıb.

- 2. Model üzrə ümumi Production Units

İstehsal həcmi model üzrə summalaşıb.

- 3. Region + Model üçün median satış

PERCENTILE_CONT istifadə edilərək model-region kəsişməsində median tapılıb.

- 4. 2020–2025 YoY Growth (Year-over-Year)

Model üzrə illik satış artım faizi hesablanıb.

3. Product Performance & Technical Analysis
- 5. Model üzrə orta Battery Capacity və Range

Model performansı müqayisə edilib.

- 6. Regionlarda ən çox satılan Model

RANK() istifadə edilərək top model müəyyən olunub.

- 7. Aylıq satışlarda model rankı

Model üzrə aylıq satış sıralaması çıxarılıb.

- 8. Regionlara görə 3 aylıq Rolling Average

REGION partition + 3-month window frame istifadə edilib.

4. Business Value Insights
- 9. Model üzrə Revenue hesablanması

Avg_Price_USD × Estimated_Deliveries

- 10. Ən baha Model

Model üzrə maksimum orta qiymət müəyyən olunub.

- 11. Region üzrə ümumi CO₂ qənaəti

Hər regionun elektrikli avtomobil təsiri analiz edilib.

- 12. Charging Station Artımı — ən yüksək olan region

Station sayı üzrə LAG() ilə aylıq artım tapılıb.

***** Çıxarılan Əsas Insight-lar (Business Findings)

Model 3 ən çox satılan modeldir (regionların əksəriyyətində).

2021–2023 dövrü satış artımında pik dövrləridir (YoY analiz).

Battery Capacity ilə Range arasında güclü müsbət korrelyasiya var.

Şimali Amerika CO₂ qənaətində liderdir.

Charging Station artımı ən çox Avropada müşahidə olunur.

Model S ən bahalı modeldir.
