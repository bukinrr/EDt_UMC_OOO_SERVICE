#Область ПрограммныйИнтерфейс

// Функция-константа, возвращает роль предмедателя медкомиссии для подписания ЭМД.
// 
// Возвращаемое значение:
//  СправочникСсылка.КлассификаторыМинЗдрава - ссылка из классификатора РолиПриПодписиМедДокументов.
//
Функция РольПредседательМедкомиссии() Экспорт
	
	Возврат ИнтеграцияЕГИСЗСервер.ЭлементКлассификатораПоID(14, "РолиПриПодписиМедДокументов");
	
КонецФункции

#КонецОбласти