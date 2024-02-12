#Область ПрограммныйИнтерфейс

// Возвращает массив групп, применимых для взрослого населения.
// 
// Возвращаемое значение:
//  Массив - массив из элементов перечисления.
//
Функция Взрослые() Экспорт
	
	Группы = Общие();
	
	пчГруппыЗдоровья = Перечисления.ГруппыЗдоровья;
	Группы.Добавить(пчГруппыЗдоровья.IIIа);
	Группы.Добавить(пчГруппыЗдоровья.IIIб);
	
	Возврат Группы;
	
КонецФункции

// Возвращает массив групп, применимых для взрослого населения.
// 
// Возвращаемое значение:
//  Массив - массив из элементов перечисления.
//
Функция Несовершеннолетние() Экспорт
	
	Группы = Общие();
	
	пчГруппыЗдоровья = Перечисления.ГруппыЗдоровья;
	Группы.Добавить(пчГруппыЗдоровья.III);
	Группы.Добавить(пчГруппыЗдоровья.IV);
	Группы.Добавить(пчГруппыЗдоровья.V);
	
	Возврат Группы;
	
КонецФункции

Функция КодыГруппПоФРНСИЕГИСЗ(Группы) Экспорт
	
	КодыГрупп = Новый Соответствие;
	
	ЗначенияПеречисления = Метаданные.Перечисления.ГруппыЗдоровья.ЗначенияПеречисления;
	
	Для Каждого Группа Из Группы Цикл
		КодыГрупп.Вставить(Группа, ЗначенияПеречисления[ЗначенияПеречисления.Индекс(Группа)].Комментарий);
	КонецЦикла;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Группы здоровья, общие для всех возрастных групп.
Функция Общие()
	
	Группы = Новый Массив;
	
	пчГруппыЗдоровья = Перечисления.ГруппыЗдоровья;
	
	Группы.Добавить(пчГруппыЗдоровья.I);
	Группы.Добавить(пчГруппыЗдоровья.II);
	
	Возврат Группы;
	
КонецФункции

#КонецОбласти