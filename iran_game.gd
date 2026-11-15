extends Node2D

const FONT_REGULAR: Font = preload("res://assets/fonts/ArabicUI-Regular.ttf")
const FONT_BOLD: Font = preload("res://assets/fonts/ArabicUI-Bold.ttf")
const SAVE_PATH := "user://iran_save.cfg"
const C := {"bg":Color("#101820"),"panel":Color("#1b2933"),"panel2":Color("#263844"),"gold":Color("#e8bd70"),"white":Color("#f5f1e8"),"muted":Color("#a8b4bd"),"green":Color("#79a889"),"red":Color("#ce786f"),"blue":Color("#709db7")}
const STAGES := [
 {"title":"شرایط تولد","opts":["👑 لاکچری و پولدار","💵 مرفه","🙂 معمولی","😐 سخت","🔥 خیلی سخت","☠️ دارک جهنمی"],"pass":5,"games":[0,1,2,3,4]},
 {"title":"محل زندگی","opts":["🏰 ویلای لوکس","🏢 آپارتمان مدرن","🏚️ خانه قدیمی","🧱 خانه بدون امکانات"],"pass":3,"games":[5,6,7]},
 {"title":"ماشین","opts":["🏎️ ماشین خارجی","🚙 شاسی‌بلند","🚗 ماشین داخلی","🚕 پراید"],"pass":3,"games":[8,9,10]},
 {"title":"شغل","opts":["💼 مدیر شرکت","👨‍💻 برنامه‌نویس","🏪 مغازه‌دار","🧑‍🏭 کارگر","🚶 بیکار"],"pass":4,"games":[11,12,13,14]},
 {"title":"وضعیت اقتصادی","opts":["💰 ثروتمند","💳 درآمد خوب","🪙 معمولی","💸 بدهکار"],"pass":3,"games":[15,16,17]},
 {"title":"اینترنت","opts":["🚀 فیبر نوری","📶 اینترنت 5G","🌐 اینترنت معمولی","🐌 اینترنت کند","🛡️ محدودیت اینترنت برای دفاع از کشور"],"pass":4,"games":[18,19,20,21]},
 {"title":"هوش","opts":["🧠 نابغه","🤓 باهوش","🙂 معمولی","🥴 کم‌هوش","🤡 خیلی کم‌هوش"],"pass":4,"games":[22,23,24,25]},
 {"title":"قیافه","opts":["✨ بسیار جذاب","😎 خوش‌قیافه","🙂 معمولی","😐 نه‌چندان جذاب","👹 بسیار بدقیافه"],"pass":4,"games":[26,27,28,29]}
]
const GAME_NAMES := ["گاوصندوق میلیاردی","مدیریت هزینه‌های لوکس","تراز دخل‌وخرج","مدیریت بحران","پرونده کمک‌هزینه","باغ و تأسیسات هوشمند","کنترل آسانسور","تعمیرات خانه","گمرک و واردات","رانندگی و پارک دشوار","خط تولید کارخانه","جلسه هیئت‌مدیره","پیدا کردن باگ","مدیریت فروشگاه","خط تولید و شیفت کاری","مدیریت دارایی‌ها","محاسبه کسورات","خرید با بودجه محدود","اتصال شبکه","تنظیم آنتن","مدیریت بسته اینترنت","دانلود فرسایشی","معمای منطقی پیشرفته","محاسبات زمان‌دار","حافظه و الگو","هزارتوی متغیر","مسابقه مدلینگ","تقارن چهره کارتونی","استودیوی عکاسی","تغییر استایل"]
const GAME_HINTS := ["کلیدها را پیدا کن و قفل‌ها را بچرخان","هزینه‌ها را در دسته درست بگذار","عددها را مرتب کن تا تراز برابر شود","منابع را بین نیازها تقسیم کن","مدارک درست را پیدا و مرتب کن","مسیر لوله‌ها را به هم وصل کن","مسافران را به آسانسور مناسب بفرست","قطعات خراب را پیدا و جایگزین کن","محموله را با سند درست تطبیق بده","از مانع‌ها عبور کن و درست پارک کن","قطعات را به ترتیب مونتاژ کن","درخواست‌ها را اولویت‌بندی کن","مسیر داده معیوب را پیدا کن","کالاها را در قفسه درست بچین","قطعات را در زمان مناسب جابه‌جا کن","دارایی‌ها را در سبد مناسب قرار بده","کسورات را محاسبه و اصلاح کن","خرید را در بودجه نگه دار","گره‌های شبکه را به هم وصل کن","زاویه آنتن را تنظیم کن","حجم اینترنت را بین دانلودها تقسیم کن","تکه‌های فایل را بازیابی کن","الگو را کامل کن","محاسبه‌ها را حل کن","ترتیب شکل‌ها را به خاطر بسپار","راه خروج را از میان پیچ‌ها پیدا کن","لباس مناسب را انتخاب کن","اجزای چهره را تنظیم کن","نور و زاویه دوربین را تنظیم کن","استایل را مطابق درخواست تغییر بده"]
var stage := 0
var screen := "splash"
var splash_time := 0.0
var active_game := -1
var active_option := -1
var progress := 0
var target := 200
var total_actions := 0
var round_no := 1
var task_index := 0
var selected_items: Array[int] = []
var puzzle_rotation := 0
var drag_start := Vector2.ZERO
var dragging := false
var toast := ""
var toast_timer := 0.0
var admin_open := false
var admin_unlocked := false
var admin_pin := "2468"
var admin_text := ""
var ending_video := ""
var completed_choices: Array = []
var config := ConfigFile.new()
var rng := RandomNumberGenerator.new()

func _ready() -> void:
 rng.randomize()
 _load_save()
 get_viewport().size_changed.connect(queue_redraw)
 screen = "splash"
 splash_time = 2.8
 queue_redraw()

func _process(delta: float) -> void:
 if screen == "splash":
  splash_time -= delta
  if splash_time <= 0.0: screen = "home"
 if toast_timer > 0.0: toast_timer -= delta
 queue_redraw()

func _draw() -> void:
 var s := get_viewport_rect().size
 draw_rect(Rect2(Vector2.ZERO,s),C.bg)
 if screen == "splash":
  _center("ایران",s.y*0.40,52,C.gold)
  _center("ساخته شده توسط",s.y*0.51,18,C.muted)
  _center("خلیل",s.y*0.56,28,C.white)
  _center("برای ورود لمس کن",s.y*0.82,14,C.muted)
  return
 if screen == "home":
  _header("ایران","یک انتخاب، یک ماجرای تازه")
  _center("زندگی را از نو انتخاب کن",s.y*0.37,27,C.white)
  _center("۸ مرحله پیش روست",s.y*0.44,17,C.muted)
  _button(Rect2(s.x*0.12,s.y*0.55,s.x*0.76,64),"شروع بازی",C.gold)
  _button(Rect2(s.x-76,32,52,46),"⚙",C.panel2)
 elif screen == "stages":
  _header("مرحله‌ها","مرحله %d از ۸" % (stage+1))
  _center(STAGES[stage]["title"],s.y*0.23,30,C.gold)
  var opts: Array = STAGES[stage]["opts"]
  var h := minf(66.0,(s.y*0.56)/opts.size())
  for i in range(opts.size()):
   var r := Rect2(s.x*0.07,s.y*0.29+i*(h+8),s.x*0.86,h)
   _button(r,String(opts[i]),C.panel2 if i != int(STAGES[stage]["pass"]) else Color("#304638"))
  _button(Rect2(20,s.y-76,116,48),"بازگشت",C.panel)
 elif screen == "game":
  _draw_game(s)
 elif screen == "admin":
  _draw_admin(s)
 elif screen == "ending":
  _header("پایان مسیر","سازنده را تماشا کن")
  _center("به پایان ۸ مرحله رسیدی",s.y*0.36,25,C.gold)
  _center("ویدیوی پایانی از پنل سازنده قابل انتخاب است",s.y*0.44,16,C.muted)
  _button(Rect2(s.x*0.12,s.y*0.57,s.x*0.76,58),"بازگشت به آغاز",C.gold)
 if toast_timer > 0.0:
  _button(Rect2(s.x*0.08,s.y-132,s.x*0.84,46),toast,C.panel2)

func _draw_game(s: Vector2) -> void:
 _header("بازی فرعی","مرحله %d  •  %s" % [stage+1,GAME_NAMES[active_game]])
 _center(GAME_HINTS[active_game],s.y*0.19,16,C.muted)
 _center("دور %d  |  مأموریت %d" % [round_no,task_index+1],s.y*0.25,15,C.gold)
 var ratio := clampf(float(progress)/float(target),0.0,1.0)
 var bar := Rect2(s.x*0.10,s.y*0.30,s.x*0.80,14)
 draw_rect(bar,C.panel2)
 draw_rect(Rect2(bar.position,Vector2(bar.size.x*ratio,bar.size.y)),C.green)
 _center("%s / %s" % [_fmt(progress),_fmt(target)],s.y*0.36,17,C.white)
 _draw_minigame_board(s)
 _button(Rect2(s.x*0.10,s.y*0.73,s.x*0.80,62),_action_label(),C.gold)
 _button(Rect2(20,s.y-76,140,48),"بازگشت به انتخاب",C.panel)
 _center("پیشرفت ذخیره می‌شود",s.y-18,12,C.muted)

func _draw_minigame_board(s: Vector2) -> void:
 var center := Vector2(s.x*0.5,s.y*0.53)
 var radius := minf(s.x*0.31,s.y*0.18)
 match active_game % 6:
  0:
   for i in range(5):
    var p := center+Vector2(cos(i*TAU/5.0),sin(i*TAU/5.0))*radius
    draw_circle(p,23,C.gold if i==puzzle_rotation%5 else C.panel2)
    _center_at(str(i+1),p,17,C.bg if i==puzzle_rotation%5 else C.white)
   _center("دایره درست را انتخاب کن",center.y+radius+34,14,C.muted)
  1:
   for i in range(4):
    var r:=Rect2(center.x-132+(i%2)*138,center.y-64+(i/2)*70,124,56)
    _button(r,["آب","برق","خوراک","هزینه"][i],C.panel2)
  2:
   for i in range(6):
    var x:=center.x-150+(i%3)*104
    var y:=center.y-64+(i/3)*78
    _button(Rect2(x,y,92,62),str((i+1)*7+task_index),C.panel2)
  3:
   for i in range(3):
    var r:=Rect2(center.x-148+i*104,center.y-35,92,92)
    draw_rect(r,C.panel2)
    _center_at(["●","◆","▲"][posmod(i+puzzle_rotation,3)],r.get_center(),30,C.gold)
  4:
   for i in range(5):
    var x:=center.x-160+i*78
    draw_rect(Rect2(x,center.y-24,62,48),C.panel2)
    draw_circle(Vector2(x+31,center.y),11,C.gold if i==posmod(puzzle_rotation,5) else C.blue)
  5:
   for i in range(3):
    var x:=center.x-115+i*115
    draw_circle(Vector2(x,center.y),36,C.panel2)
    _center_at(["۱","۲","۳"][i],Vector2(x,center.y),22,C.gold)

func _action_label() -> String:
 match active_game % 6:
  0: return "چرخاندن قفل / انتخاب قطعه"
  1: return "برداشتن و دسته‌بندی"
  2: return "انتخاب و مرتب‌سازی"
  3: return "اتصال قطعات"
  4: return "جابجایی و مونتاژ"
  _: return "انجام حرکت بعدی"

func _draw_admin(s: Vector2) -> void:
 _header("پنل سازنده","تنظیمات بازی ایران")
 if not admin_unlocked:
  _center("رمز پنل سازنده را وارد کن",s.y*0.28,20,C.white)
  _center("رمز پیش‌فرض: 2468",s.y*0.35,15,C.muted)
  _button(Rect2(s.x*0.2,s.y*0.44,s.x*0.6,62),admin_text if admin_text!="" else "ورود",C.panel2)
 else:
  _center("مرحله فعال: %d از ۸" % (stage+1),s.y*0.25,19,C.white)
  _button(Rect2(s.x*0.1,s.y*0.32,s.x*0.8,52),"مرحله بعد / قبلی",C.panel2)
  _button(Rect2(s.x*0.1,s.y*0.42,s.x*0.8,52),"تغییر رمز پنل",C.panel2)
  _button(Rect2(s.x*0.1,s.y*0.52,s.x*0.8,52),"انتخاب ویدیوی پایانی",C.panel2)
  _center("ویدیو: "+(ending_video if ending_video!="" else "انتخاب نشده"),s.y*0.65,13,C.muted)
 _button(Rect2(20,s.y-76,116,48),"بازگشت",C.panel)

func _center(t:String,y:float,size:int,color:Color) -> void:
 var w:=get_viewport_rect().size.x
 draw_string(FONT_BOLD,Vector2(0,y),t,HORIZONTAL_ALIGNMENT_CENTER,w,size,color)

func _center_at(t:String,p:Vector2,size:int,color:Color) -> void:
 draw_string(FONT_BOLD,Vector2(p.x-70,p.y+size*0.34),t,HORIZONTAL_ALIGNMENT_CENTER,140,size,color)

func _header(title:String,sub:String) -> void:
 var s:=get_viewport_rect().size
 draw_rect(Rect2(0,0,s.x,112),C.panel)
 draw_string(FONT_BOLD,Vector2(22,45),title,HORIZONTAL_ALIGNMENT_LEFT,-1,24,C.gold)
 draw_string(FONT_REGULAR,Vector2(22,78),sub,HORIZONTAL_ALIGNMENT_LEFT,-1,13,C.muted)
 _button(Rect2(s.x-72,28,52,48),"⚙",C.panel2)

func _button(r:Rect2,t:String,color:Color) -> void:
 draw_rect(r,color,true)
 draw_rect(r,Color(1,1,1,0.09),false,1.0)
 draw_string(FONT_BOLD,Vector2(r.position.x+8,r.position.y+r.size.y*0.62),t,HORIZONTAL_ALIGNMENT_CENTER,r.size.x-16,17,C.white)

func _hit(r:Rect2,p:Vector2)->bool:
 return r.has_point(p)

func _input(event:InputEvent)->void:
 if event is InputEventScreenTouch:
  var e:=event as InputEventScreenTouch
  if e.pressed:
   drag_start=e.position
   dragging=true
  else:
   if dragging: _tap(e.position,drag_start.distance_to(e.position))
   dragging=false
 elif event is InputEventMouseButton and event.button_index==MOUSE_BUTTON_LEFT:
  var e:=event as InputEventMouseButton
  if e.pressed: drag_start=e.position; dragging=true
  else:
   if dragging: _tap(e.position,drag_start.distance_to(e.position))
   dragging=false
 elif event is InputEventScreenDrag and dragging:
  if drag_start.distance_to((event as InputEventScreenDrag).position)>35:
   puzzle_rotation=(puzzle_rotation+1)%5
   queue_redraw()

func _tap(p:Vector2,travel:float)->void:
 var s:=get_viewport_rect().size
 if screen=="splash": screen="home"; return
 if screen=="home":
  if p.y>s.y*0.5 and p.y<s.y*0.75: screen="stages"
  elif p.x>s.x-100: screen="admin"
 elif screen=="stages":
  if p.y>s.y-100: screen="home"; return
  var opts:Array=STAGES[stage]["opts"]
  var h:=minf(66.0,(s.y*0.56)/opts.size())
  var idx:=int(floor((p.y-s.y*0.29)/(h+8)))
  if idx>=0 and idx<opts.size():
   if idx==int(STAGES[stage]["pass"]):
    stage+=1
    if stage>=STAGES.size(): screen="ending"; stage=7
    _save()
   else:
    active_option=idx
    active_game=int(STAGES[stage]["games"][idx])
    screen="game"
    _save()
  elif p.x>s.x-100: screen="admin"
 elif screen=="game":
  if p.y>s.y-105 and p.x<190: screen="stages"; _save(); return
  if p.y>s.y*0.69 and p.y<s.y*0.84: _advance_game()
  elif p.y>s.y*0.38 and p.y<s.y*0.69:
   puzzle_rotation=(puzzle_rotation+1)%5
   _advance_game()
  _save()
 elif screen=="admin":
  if p.y>s.y-100: screen="home"; return
  if not admin_unlocked:
   admin_text+="2468"[posmod(admin_text.length(),4)]
   if admin_text.length()>=4:
    admin_unlocked=admin_text.ends_with(admin_pin)
    admin_text=""
    if not admin_unlocked: _notify("رمز نادرست است")
  else:
   if p.y<s.y*0.4: stage=posmod(stage+1,8)
   elif p.y<s.y*0.51: admin_pin="1357"; _notify("رمز پنل تغییر کرد")
   elif p.y<s.y*0.61: _notify("برای انتخاب ویدیو از فایل‌گزین اندروید استفاده می‌شود")
  _save()
 elif screen=="ending":
  screen="home"; stage=0

func _advance_game()->void:
 total_actions+=1
 progress+=1
 var extra:=int(progress/maxi(1,target))
 if progress>=target:
  progress=0
  round_no+=1
  task_index+=1
  target+=target*2
  puzzle_rotation=rng.randi_range(0,4)
  _notify("مأموریت تازه: "+GAME_HINTS[active_game])
 elif total_actions%25==0:
  target+=int(target*0.15)
  _notify("یک بخش تازه اضافه شد؛ ادامه بده")
 else:
  _notify(["خوب پیش می‌روی","یک قطعه دیگر پیدا شد","درخواست تازه رسید","مرحله بررسی تمدید شد"][rng.randi_range(0,3)])

func _fmt(n:int)->String:
 return str(n).reverse().insert(0,"").reverse() if n<1000 else str(n)

func _notify(t:String)->void:
 toast=t
 toast_timer=2.2

func _save()->void:
 config.set_value("progress","stage",stage)
 config.set_value("progress","screen",screen)
 config.set_value("progress","active_game",active_game)
 config.set_value("progress","progress",progress)
 config.set_value("progress","target",target)
 config.set_value("progress","total_actions",total_actions)
 config.set_value("progress","round_no",round_no)
 config.set_value("progress","task_index",task_index)
 config.set_value("admin","pin",admin_pin)
 config.set_value("admin","ending_video",ending_video)
 config.save(SAVE_PATH)

func _load_save()->void:
 if config.load(SAVE_PATH)!=OK: return
 stage=clampi(int(config.get_value("progress","stage",0)),0,7)
 active_game=int(config.get_value("progress","active_game",-1))
 progress=int(config.get_value("progress","progress",0))
 target=maxi(200,int(config.get_value("progress","target",200)))
 total_actions=int(config.get_value("progress","total_actions",0))
 round_no=maxi(1,int(config.get_value("progress","round_no",1)))
 task_index=int(config.get_value("progress","task_index",0))
 admin_pin=str(config.get_value("admin","pin","2468"))
 ending_video=str(config.get_value("admin","ending_video",""))
