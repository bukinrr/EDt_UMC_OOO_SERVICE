#Область РазделОписанияПеременных

&НаКлиенте
Перем ДокументСформирован;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЦветСтрокой = "rgba(0,0,0,%1)";
	
	ЗаполнитьHTML();
	ШиринаЛинии = 2;
	Непрозрачность = 10;
	
	КартинкаИлиДвоичныеДанные = ПолучитьИзВременногоХранилища(Параметры.ДанныеКартинки.АдресВХранилище);
	Если ТипЗнч(КартинкаИлиДвоичныеДанные) = Тип("Картинка") Тогда
		ДДКартинки = КартинкаИлиДвоичныеДанные.ПолучитьДвоичныеДанные();
	ИначеЕсли ТипЗнч(КартинкаИлиДвоичныеДанные) = Тип("ДвоичныеДанные") Тогда
		ДДКартинки = КартинкаИлиДвоичныеДанные;
	Иначе
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Base64Картинки = СтрШаблон("data:image/%1;base64,%2", Параметры.ДанныеКартинки.Расширение, Base64Строка(ДДКартинки));
	
	Если Параметры.Свойство("УИДФормы") Тогда
		УИДФормы = Параметры.УИДФормы;
	КонецЕсли;

	Если Параметры.Свойство("АдресРисунка") И ЗначениеЗаполнено(Параметры.АдресРисунка) Тогда
		Base64Рисунка = СтрШаблон("data:image/png;base64,%1", Base64Строка(ПолучитьИзВременногоХранилища(Параметры.АдресРисунка)));
	КонецЕсли;
	
	Если Параметры.Свойство("ШаблонПриема") Тогда
		ИдентификаторНастроек = СтрШаблон("%1:%2", Параметры.ШаблонПриема.УникальныйИдентификатор(), Параметры.ИдентификаторРисунка);
	Иначе
		Элементы.Сохранить.Видимость = Ложь;
		Элементы.Закрыть.Видимость = Истина;
		Элементы.Закрыть.КнопкаПоУмолчанию = Истина;
	КонецЕсли;
	
	ЗаполнитьПанельНастроек();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ДокументСформирован = Ложь;
	ОбновитьСтроковоеЗначениеЦвета();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Назад(Команда)
	
	Элементы.HTML.Документ.defaultView.undo();
	ОбновитьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)
	
	Элементы.HTML.Документ.defaultView.clear_canvas();
	ОбновитьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	
	Если Элементы.HTML.Документ.defaultView.getLengthArray() = 0 Тогда
		АдресРисунка = "";
	Иначе
		Результат = Элементы.HTML.Документ.defaultView.save();
		АдресРисунка = СохранитьРисунокВХранилище(Результат, УИДФормы);
	КонецЕсли;
	
	НастройкиВХранилище(ИдентификаторНастроек, Новый Структура("Инструмент, ЦветЛинии, ШиринаЛинии, Непрозрачность", Инструмент, ЦветЛинии, ШиринаЛинии, Непрозрачность));
	Закрыть(АдресРисунка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ИнструментПриИзменении(Элемент = Неопределено)
	
	Если Инструмент = 2 Тогда
		Элементы.HTML.Документ.defaultView.eraser(Истина);
	Иначе
		Элементы.HTML.Документ.defaultView.eraser(Ложь);
		Элементы.HTML.Документ.defaultView.changeTool(Инструмент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЦветПриИзменении()
	
	Элементы.HTML.Документ.defaultView.changeColor(СтрШаблон(ЦветСтрокой, Формат(Непрозрачность / 10, "ЧДЦ=1; ЧРД=.; ЧГ=0")));
	
КонецПроцедуры

&НаКлиенте
Процедура РазмерКистиПриИзменении(Элемент = Неопределено)
	
	Элементы.HTML.Документ.defaultView.changeWidth(Строка(ШиринаЛинии));
	
КонецПроцедуры

&НаКлиенте
Процедура HTMLДокументСформирован(Элемент)
	
	Попытка
		ДокументСформирован = Элементы.HTML.Документ.defaultView.Check();
	Исключение
		СИ = Новый СистемнаяИнформация;
		ТекстПредупреждения = СтрШаблон(НСтр("ru='Функционал редактирования картинок недоступен.
			|Вероятно, используемая версия платформы (%1; тип: %2) не поддерживает этот функционал.'"), СИ.ВерсияПриложения, СИ.ТипПлатформы);
		ПоказатьПредупреждение(Новый ОписаниеОповещения("ПослеЗакрытияПредупреждения", ЭтотОбъект), ТекстПредупреждения);
		Возврат;
	КонецПопытки;
	
	Элементы.HTML.Документ.defaultView.setBackground(Base64Картинки);
	
	Если ЗначениеЗаполнено(Base64Рисунка) Тогда
		Если Элементы.HTML.Документ.defaultView.canvasIsExist() Тогда
			Элементы.HTML.Документ.defaultView.load(Base64Рисунка);
			ОбновитьДоступностьЭлементов(Истина);
		Иначе
			ПодключитьОбработчикОжидания("ЗагрузитьРисунок", 0.1, Истина);
		КонецЕсли;
	Иначе
		ОбновитьДоступностьЭлементов();
	КонецЕсли;
	
	НастроитьПараметрыРисования();
	
КонецПроцедуры

&НаКлиенте
Процедура HTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	Если ДокументСформирован Тогда
		ОбновитьДоступностьЭлементов();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьДоступностьЭлементов(ЗагрузкаРисунок = Ложь)
	
	// При загрузке рисунка в массиве ещё нет ни одного элемента - элемент добавится после окончания загрузки.
	ЕстьЭлементы = Элементы.HTML.Документ.defaultView.getLengthArray() > 0;
	Элементы.Назад.Доступность = ЕстьЭлементы Или ЗагрузкаРисунок;
	Элементы.Очистить.Доступность = ЕстьЭлементы Или ЗагрузкаРисунок;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьHTML()
	
	HTML = 
		"<html>
		|	<head>
		|		<meta http-equiv='X-UA-Compatible' content='IE=edge'>
		|		<style>
		|			canvas {
		|				border: 1px solid #7B899B;
		|			}
		|		</style>
		|		<script type='text/javascript'>
		|			var canvas;
		|			var canvasPath;
		|			var context;
		|			var contextPath;
		|			
		|			var startx;
		|			var starty;
		|			
		|			
		|			// 0 = brush; 1 = straight line;
		|			let tool = 0;
		|			let eraserOn = false;
		|			
		|			let draw_color = 'rgba(0,0,0,1)';
		|			let draw_width = '2';
		|			let is_drawing = false;
		|			let restore_array = [];
		|			let path_array = [];
		|			let backgroundAlreadyLoaded = false;
		|			
		|			var imageBackground = new Image();
		|			imageBackground.onload = imgOnload;
		|			
		|			function Check() {
		|				return true;
		|			}
		|			
		|			function setBackground(src) {
		|				imageBackground.src = src;
		|			}
		|			
		|			function imgOnload() {
		|				canvasBG = document.getElementById('canvasBG');
		|				contextBG = canvasBG.getContext('2d');
		|				canvasBG.width = this.naturalWidth;
		|				canvasBG.height = this.naturalHeight;
		|				contextBG.drawImage(this, 0, 0);
		|				canvas = document.getElementById('canvasDrawLayer');
		|				canvas.width = this.naturalWidth;
		|				canvas.height = this.naturalHeight;
		|				context = canvas.getContext('2d');
		|				context.lineCap = 'round';
		|				context.lineJoin = 'round';
		|				
		|				canvasPath = document.getElementById('canvasPathDrawLayer');
		|				canvasPath.width = this.naturalWidth;
		|				canvasPath.height = this.naturalHeight;
		|				contextPath = canvasPath.getContext('2d');
		|				contextPath.lineCap = 'round';
		|				contextPath.lineJoin = 'round';
		|				
		|				canvasPath.addEventListener('touchstart', start, false);
		|				canvasPath.addEventListener('touchmove', draw, false);
		|				canvasPath.addEventListener('mousedown', start, false);
		|				canvasPath.addEventListener('mousemove', draw, false);
		|				canvasPath.addEventListener('touchend', stop, false);
		|				canvasPath.addEventListener('mouseup', stop, false);
		|				canvasPath.addEventListener('mouseout', stop, false);
		|			}
		|			
		|			function start(event) {
		|				context.globalCompositeOperation = eraserOn ? 'destination-out' : 'source-over';
		|				is_drawing = true;
		|				
		|				if (eraserOn) {
		|					var rect = canvas.getBoundingClientRect();
		|					context.beginPath();
		|					startx = event.clientX - rect.left;
		|					starty = event.clientY - rect.top;
		|					context.moveTo(startx, starty);
		|				} else {
		|					var rect = canvasPath.getBoundingClientRect();
		|					if (tool == 0) {
		|						contextPath.beginPath();
		|					}
		|					startx = event.clientX - rect.left;
		|					starty = event.clientY - rect.top;
		|					contextPath.moveTo(startx, starty);
		|				}
		|				contextPath.strokeStyle = draw_color;
		|				contextPath.lineWidth = draw_width;
		|				context.strokeStyle = draw_color;
		|				context.lineWidth = draw_width;
		|				
		|				event.preventDefault();
		|				path_array.push([startx, starty]);
		|			}
		|			
		|			function draw(event) {
		|				if (is_drawing) {
		|					
		|					var rect = canvasPath.getBoundingClientRect();
		|					
		|					if (eraserOn) {
		|						var rect = canvas.getBoundingClientRect();
		|						context.lineTo(event.clientX - rect.left, event.clientY - rect.top);
		|						context.stroke();
		|					} else if (tool == 1) {
		|						contextPath.beginPath();
		|						contextPath.clearRect(0, 0, canvasPath.width, canvasPath.height);
		|						contextPath.moveTo(startx, starty);
		|						contextPath.lineTo(event.clientX - rect.left, event.clientY - rect.top);
		|						contextPath.stroke();
		|					} else {
		|						contextPath.closePath();
		|						contextPath.clearRect(0, 0, canvasPath.width, canvasPath.height);
		|						contextPath.beginPath();
		|						path_array.push([event.clientX - rect.left, event.clientY - rect.top]);
		|						contextPath.moveTo.apply(contextPath, path_array[0]);
		|						path_array.forEach(element => contextPath.lineTo(...element));
		|						contextPath.stroke();
		|					}
		|				}
		|				event.preventDefault();
		|			}
		|			
		|			function stop(event) {
		|				if (is_drawing) {
		|					is_drawing = false;
		|					
		|					if (eraserOn){
		|						context.closePath();
		|					} else {
		|						var rect = canvasPath.getBoundingClientRect();
		|						path_array.push([event.clientX - rect.left, event.clientY - rect.top]);
		|						contextPath.closePath();
		|						contextPath.clearRect(0, 0, canvasPath.width, canvasPath.height);
		|						
		|						context.beginPath();
		|						context.moveTo.apply(context, path_array[0]); // es5 friendly
		|						path_array.forEach(element => context.lineTo(...element));
		|						context.stroke();
		|						context.closePath();
		|					}
		|					restore_array.push(context.getImageData(0, 0, canvas.width, canvas.height));
		|					path_array = [];
		|				}
		|				event.preventDefault();
		|			}
		|			
		|			function clear_canvas() {
		|				context.clearRect(0, 0, canvas.width, canvas.height);
		|				restore_array = [];
		|			}
		|			
		|			function undo() {
		|				let amount = restore_array.length;
		|				if (amount > 0) {
		|					restore_array.pop();
		|					if (amount > 1) {
		|						context.putImageData(restore_array[restore_array.length - 1], 0, 0);
		|					} else {
		|						context.clearRect(0, 0, canvas.width, canvas.height);
		|					}
		|				}
		|			}
		|			
		|			function changeColor(colorValue) {
		|				draw_color = colorValue;
		|			}
		|			
		|			function changeWidth(widthValue) {
		|				draw_width = widthValue;
		|			}
		|			
		|			function save() {
		|				return canvas.toDataURL('image/png', 0.1);
		|			}
		|			
		|			function load(pic) {
		|				clear_canvas();
		|				var imagePic = new Image();
		|				imagePic.src = pic;
		|				imagePic.onload = imagePicOnload;
		|			}
		|			
		|			function imagePicOnload() {
		|				context.drawImage(this, 0, 0);
		|				restore_array.push(context.getImageData(0, 0, canvas.width, canvas.height));
		|			}
		|			
		|			function getLengthArray() {
		|				return restore_array.length;
		|			}
		|			
		|			function changeTool(value) {
		|				tool = value;
		|			}
		|			
		|			function canvasIsExist() {
		|				return canvas != null;
		|			}
		|			
		|			function eraser(turnOn) {
		|				eraserOn = turnOn;
		|			}
		|		</script>
		|	</head>
		|	<body>
		|		<div style='position: static'>
		|			<canvas style='position: absolute; left: 0; top: 0; z-index: 0;' id='canvasBG'>
		|				<img id='imageBackground'></img>
		|			</canvas>
		|			<canvas style='position: absolute; left: 0; top: 0; z-index: 1;' id='canvasDrawLayer'></canvas>
		|			<canvas style='position: absolute; left: 0; top: 0; z-index: 2;' id='canvasPathDrawLayer'></canvas>
		|		</div>
		|	</body>
		|</html>";
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СохранитьРисунокВХранилище(Результат, УИДФормы)
	
	ДДРезультат = Base64Значение(СтрРазделить(Результат,",")[1]);
	Возврат ПоместитьВоВременноеХранилище(ДДРезультат, УИДФормы);
	
КонецФункции

&НаКлиенте
Процедура ЗагрузитьРисунок()
	
	// Может потребоваться некоторое время для отрисовки картинки.
	// Рисунок можно помещать только тогда, когда картинка уже отрисована, т.к. canvas для рисунка формируется при формировании canvas для картинки.
	Если Элементы.HTML.Документ.defaultView.canvasIsExist() Тогда
		Элементы.HTML.Документ.defaultView.load(Base64Рисунка);
		ОтключитьОбработчикОжидания("ЗагрузитьРисунок");
		ОбновитьДоступностьЭлементов(Истина);
	Иначе
		ПодключитьОбработчикОжидания("ЗагрузитьРисунок", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПанельНастроек()
	
	НастройкиРисункаШаблона = НастройкиИзХранилища(ИдентификаторНастроек);
	Если НастройкиРисункаШаблона <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, НастройкиРисункаШаблона);
		Если НастройкиРисункаШаблона.Свойство("Цвет") Тогда
			ЦветСтрокой = НастройкиРисункаШаблона.Цвет;
			
			Попытка
				ЧастиЦвета = СтрРазделить(СтрЗаменить(ЦветСтрокой, "rgba(", ""), ",", Ложь);
				ЦветЛинии = Новый Цвет(СокрЛП(ЧастиЦвета[0]), СокрЛП(ЧастиЦвета[1]), СокрЛП(ЧастиЦвета[2]));
			Исключение
				ЦветЛинии = Новый Цвет(0,0,0);
			КонецПопытки;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПараметрыРисования()
	
	ИнструментПриИзменении();
	ЦветПриИзменении();
	РазмерКистиПриИзменении();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура НастройкиВХранилище(КлючОбъекта, Настройки)
	
	ХранилищеОбщихНастроек.Сохранить(Строка(КлючОбъекта), , Настройки);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НастройкиИзХранилища(КлючОбъекта)
	
	Возврат ХранилищеОбщихНастроек.Загрузить(Строка(КлючОбъекта));
	
КонецФункции

&НаКлиенте
Процедура НепрозрачностьПриИзменении(Элемент)
	
	ЦветПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияПредупреждения(ДополнительныеПараметры) Экспорт
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ЦветЛинииПриИзменении(Элемент)
	
	ОбновитьСтроковоеЗначениеЦвета();
	ЦветПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСтроковоеЗначениеЦвета()
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	Если СтроковыеФункцииКлиентСервер.СравнитьВерсии(СистемнаяИнформация.ВерсияПриложения, "8.3.23.0") >= 0 Тогда
		АбсолютныйЦвет = ЦветЛинии.ПолучитьАбсолютный();
	Иначе
		АбсолютныйЦвет = ПреобразоватьЦветВАбсолютный(ЦветЛинии);
	КонецЕсли;
	
	ЦветСтрокой = СтрШаблон("rgba(%1,%2,%3,%%1)", АбсолютныйЦвет.Красный, АбсолютныйЦвет.Зеленый, АбсолютныйЦвет.Синий);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПреобразоватьЦветВАбсолютный(ЦветЛинии)
	
	Если ЦветЛинии.Вид = ВидЦвета.Абсолютный Тогда
		Возврат ЦветЛинии;
	КонецЕсли;
	
	ФорматированныйДокумент = Новый ФорматированныйДокумент;
	ФорматированныйДокумент.УстановитьФорматированнуюСтроку(Новый ФорматированнаяСтрока("Цвет", , ЦветЛинии));
	
	АбсолютныйЦвет = ФорматированныйДокумент.Элементы[0].Элементы[0].ЦветТекста;
	Если АбсолютныйЦвет.Вид = ВидЦвета.Абсолютный Тогда
		Возврат АбсолютныйЦвет;
	КонецЕсли;
	
	ТекстHTML = "";
	Вложения = Новый Структура;
	ФорматированныйДокумент.ПолучитьHTML(ТекстHTML, Вложения);
	ФорматированныйДокумент.УстановитьHTML(ТекстHTML, Вложения);
	АбсолютныйЦвет = ФорматированныйДокумент.Элементы[0].Элементы[0].ЦветТекста;
	Если АбсолютныйЦвет.Вид = ВидЦвета.Абсолютный Тогда
		Возврат АбсолютныйЦвет;
	КонецЕсли;
	
	Возврат Новый Цвет(0,0,0);
	
КонецФункции

#КонецОбласти