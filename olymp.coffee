OLYMP = () ->
  if arguments[0]!=undefined
    primary = arguments[0]

    byDragGroup = $('[draggroup="'+primary+'"]')
    if byDragGroup.length>0
      OLYMP.nearly = primary
      return OLYMP.fn

    byID = $('[olympid="'+primary+'"]')
    if byID.length>0
      OLYMP.nearly = byID
      return OLYMP.fn

  return OLYMP




OLYMP.fn = {}
OLYMP.fn.getArgs = () ->
  args = [].slice.call(arguments[0])
  args.unshift(OLYMP.nearly)
  delete OLYMP.nearly
  return args

OLYMP.fn.click = {}
OLYMP.fn.click.on = () -> OLYMP.click.on.apply(@ , OLYMP.fn.getArgs(arguments))
OLYMP.fn.click.off = () -> OLYMP.click.off.apply(@ , OLYMP.fn.getArgs(arguments))

OLYMP.fn.drag = {}
OLYMP.fn.drag.on = () -> OLYMP.drag.on.apply(@ , OLYMP.fn.getArgs(arguments))
OLYMP.fn.drag.off = () -> OLYMP.drag.off.apply(@ , OLYMP.fn.getArgs(arguments))


OLYMP.fn.input = {}
OLYMP.fn.input.on = () -> OLYMP.input.on.apply(@ , OLYMP.fn.getArgs(arguments))
OLYMP.fn.input.off = () -> OLYMP.input.off.apply(@ , OLYMP.fn.getArgs(arguments))
OLYMP.fn.input.get = () -> OLYMP.input.get.apply(@ , OLYMP.fn.getArgs(arguments))
OLYMP.fn.input.set = () -> OLYMP.input.set.apply(@ , OLYMP.fn.getArgs(arguments))
OLYMP.fn.input.wrong = () -> OLYMP.input.wrong.apply(@ , OLYMP.fn.getArgs(arguments))







# fix for native typeof
OLYMP.__typeOf = (value) ->
  s = typeof value
  if s == 'object'
    if value
      tty = Object.prototype.toString.call(value)
      if (tty != '[object Object]')
        if (tty == '[object Array]')
          s = 'array'
        else
          s = 'null'
  return s



OLYMP.start = (AT) =>
  if OLYMP.AT || OLYMP.__typeOf(AT)!='object' then return OLYMP
  OLYMP.__storage = {}
  OLYMP.__storage.currentscreen = ''
  OLYMP.__storage.activeinput = null
  OLYMP.__storage.callbackoninputdeactivate=null
  OLYMP.__storage.callbackoninputenter=null
  OLYMP.actiondata = {}
  OLYMP.obj=null
  OLYMP.char=null
  OLYMP.event=null
  OLYMP.AT = AT
  $('.card_header>.card_name').remove()
  $('.card_header>.score_wrapper').remove()
  $('.card_header').width(120)
  $('#board').addClass('cr')
  AT.place.addClass("placesettings")
  AT.scene = $.div('scene').attr({'olympid':'scene'}).appendTo(AT.place)
  return OLYMP



OLYMP.finish = (a) ->
  OLYMP.click.off()
  OLYMP.drag.off()
  if a=='trial'
    OLYMP.AT.place.find(".card_header a.card_back").trigger $$.buttonDown('up')
  else
    OLYMP.AT.tutor.the_end()



OLYMP.animate = () =>
  args = OLYMP.__parseArguments(arguments)
  if args.subject==null then return false
  selector = args.subject
  css = args.object[0] || {}
  duration = args.number[0] || 1000
  easing = args.string[0] || 'linear'
  cb = args.function[0]
  OLYMP.lock()
  $(selector).animate css,duration,easing, =>
    OLYMP.unlock()
    if cb then cb()
  return OLYMP


OLYMP.lock = () => $.div('scenelocker').appendTo($('.scene'))
OLYMP.unlock = (a) => if a then $('.scenelocker').remove(); else $('.scenelocker').eq(0).remove();


OLYMP.delay = () =>
  args = OLYMP.__parseArguments(arguments)
  duration = args.number[0] || 1000
  cb = args.function[0]
  # scenelocker = $.div('scenelocker').appendTo($('.scene'))
  OLYMP.lock() 
  $.delay duration, =>
    # scenelocker.remove()
    OLYMP.unlock()
    if cb then cb()
  return OLYMP



OLYMP.screen = () ->
  if arguments.length==0 then return OLYMP.__storage.currentscreen
  args = OLYMP.__parseArguments(arguments)
  if !args.string[0] then return false
  duration = args.number[0] || 0
  screen = args.string[0]
  cb = args.function[0]

  a = $('[data-screen]').not('[data-screen='+screen+']')
  b = $('[data-screen="'+screen+'"]')
  OLYMP.__storage.currentscreen = screen

  if duration==0
    a.css({opacity:0}).hide()
    b.css({opacity:1}).show()
    if cb then cb()
  else

    if $('[data-screen]').length>1
      OLYMP.animate a, {'opacity':0}, duration/2, ->
        a.hide()
      $.delay duration/2 , ->
        b.show()
        OLYMP.animate b, {'opacity':1}, duration/2
    else
      b.show()
      OLYMP.animate b, {'opacity':1}, duration

    $.delay duration, =>
      if cb then cb()
      return OLYMP







OLYMP.__parseArguments = () ->
  fnl = {}
  fnl.string = []
  fnl.number = []
  fnl.breaker = false
  fnl.array = []
  fnl.object = []
  fnl.function = []
  fnl.subject = null

  for i in [0...arguments[0].length]
    arg = arguments[0][i]
    if arg==undefined then continue
    if arg instanceof jQuery then fnl.subject = arg
    else
      if arg==false then fnl.breaker=true
      else
        if OLYMP.__typeOf(arg)!=undefined
          fnl[OLYMP.__typeOf(arg)].push(arg)

  if arguments[1]==undefined
    if fnl.subject==null && fnl.string.length>0
      ii=-1
      for  i in [0...fnl.string.length]
        ii++
        b = $(fnl.string[ii])
        if b.length>0
          fnl.subject = b
          fnl.string.splice(ii,1)
          break
  fnl



OLYMP.__runcb = (cb) -> if OLYMP.__typeOf(cb)=='function' then return cb()


# OLYMP.render = (layout) =>
#   if OLYMP.__typeOf(layout)=='object'
#     layout = [layout]
#
#   for i in [0...layout.length]
#     if $('[data-screen="'+layout[i]['screen']+'"]').length==0
#       scrn = $.div('').attr('data-screen',layout[i]['screen']).hide().css({'opacity':0}).appendTo(OLYMP.AT.scene)
#     else
#       scrn = $('[data-screen="'+layout[i]['screen']+'"]').eq(0)
#
#     if layout[i]['parent']==undefined
#       appendPlace = scrn
#     else
#       appendPlace = $('[olympid="'+layout[i]['parent']+'"]')
#
#     currelem = $.div(layout[i]['class']).css({'position':'absolute','left':layout[i]['x'],'top':layout[i]['y']}).html(layout[i]['content']).appendTo(appendPlace)
#     if layout[i]['css']!=undefined then currelem.css(layout[i]['css'])
#     if layout[i]['attr']!=undefined then currelem.attr(layout[i]['attr'])
#     if layout[i]['id']!=undefined then currelem.attr('olympid',layout[i]['id'])
#
#     if layout[i]['digits']!=undefined then currelem.attr('olympdigits',layout[i]['digits']).append('<span></span>')
#
#     if layout[i]['draggroup']!=undefined
#       currelem.attr('draggroup',layout[i]['draggroup'])
#       if layout[i]['slotid']!=undefined
#           currelem.attr({'slotid':layout[i]['slotid'],'storing':''})
#       else
#           currelem.attr({'itemid':layout[i]['itemid'],'init_x':layout[i]['x'],'init_y':layout[i]['y']})
#   return OLYMP




OLYMP.render = (layout) =>
  if OLYMP.__typeOf(layout)=='object'
    layout = [layout]

  adobjx = []

  for i in [0...layout.length]
    if $('[data-screen="'+layout[i]['screen']+'"]').length==0
      scrn = $.div('').attr('data-screen',layout[i]['screen']).hide().css({'opacity':0}).appendTo(OLYMP.AT.scene)
    else
      scrn = $('[data-screen="'+layout[i]['screen']+'"]').eq(0)

    if layout[i]['parent']==undefined
      appendPlace = scrn
    else
      appendPlace = $('[olympid="'+layout[i]['parent']+'"]')

    currelem = $.div(layout[i]['class']).css({'position':'absolute','left':layout[i]['x'],'top':layout[i]['y']}).html(layout[i]['content']).appendTo(appendPlace)
    if layout[i]['css']!=undefined then currelem.css(layout[i]['css'])
    if layout[i]['attr']!=undefined then currelem.attr(layout[i]['attr'])
    if layout[i]['id']!=undefined then currelem.attr('olympid',layout[i]['id'])

    if layout[i]['digits']!=undefined then currelem.attr('olympdigits',layout[i]['digits']).append('<span></span>')

    if layout[i]['draggroup']!=undefined
      currelem.attr('draggroup',layout[i]['draggroup'])
      if layout[i]['slotid']!=undefined
          currelem.attr({'slotid':layout[i]['slotid'],'storing':''})
      else
          currelem.attr({'itemid':layout[i]['itemid'],'init_x':layout[i]['x'],'init_y':layout[i]['y']})
    adobjx.push currelem
  # return adobjx
  if adobjx.length>1
    return adobjx
  else
    return adobjx[0]















# удаляет все обработчики событий.
OLYMP.__clearEvents = (selector) ->
  $(document).off "mousedown touchstart touchmove mousemove touchend mouseup mouseleave", selector
  $(selector).removeClass('olympclickable') #.off "mousedown touchstart"






OLYMP.click = {}
OLYMP.click.__storage ={}

OLYMP.click.on = () ->
  args = OLYMP.__parseArguments(arguments)
  if args.subject
    if args.subject.length==0 then return false
    OLYMP.click.__storage[args.subject.selector] = true
    # args.subject.addClass('olympclickable').on "mousedown touchstart", (event) ->
    OLYMP.__clearEvents(args.subject.selector)
    args.subject.addClass('olympclickable')
    $(document).on "mousedown touchstart", args.subject.selector, (event) ->
      event.preventDefault()
      OLYMP.event = event
      OLYMP.obj = $(this)
      # if args.function[0] then args.function[0]()
      OLYMP.__runcb args.function[0]


OLYMP.click.off = () ->
  args = OLYMP.__parseArguments(arguments)
  if args.subject
    keys = [args.subject.selector]
  else
    keys = Object.keys(OLYMP.click.__storage)
  for i in [0...keys.length]
     #args.subject.selector
    delete OLYMP.click.__storage[keys[i]]
    OLYMP.__clearEvents(keys[i])





























OLYMP.drag = {}
OLYMP.drag.__storage = {}
# OLYMP.drag.slots = {}
# OLYMP.drag.slotcoordinates = []
OLYMP.drag.slot = null



OLYMP.drag.off = () ->
  if arguments[0]
    keys = [arguments[0]]
  else
    keys = Object.keys(OLYMP.drag.__storage)
  for i in [0...keys.length]
    delete OLYMP.drag.__storage[keys[i]]
    OLYMP.__clearEvents('[draggroup="'+keys[i]+'"][itemid]')






OLYMP.drag.on = () ->
  args = OLYMP.__parseArguments(arguments,true)
  subject = $('[draggroup="'+args.string[0]+'"][itemid]')
  OLYMP.__clearEvents(subject)

  options = {}
  if args.string[1]
    argarr = args.string[1].toLowerCase().split(',')
    for i in [0...argarr.length]
      argg = argarr[i].trim()
      if argg.indexOf(':')<0
         options[argg] = true
      else
        tmp = argg.split(':')
        options[tmp[0]] = (tmp[1].trim())

  if args.number[0]!=undefined then duration = args.number[0]; else duration = 1000

  # cb1 = cb2 = null
  # if args.function[0]!=undefined then cb1=args.function[0]
  # if args.function[1]!=undefined then cb2=args.function[1]
  # if cb2==null then cb2=cb1

  # onStart = onMove = beforeStart = moveonce = null
  hoverClass = ''
  # if args.object[0]
  #   if args.object[0].beforestart!=undefined then beforeStart=args.object[0].beforestart
  #   if args.object[0].start!=undefined then onStart=args.object[0].start
  #   if args.object[0].move!=undefined then onMove=args.object[0].move
  #   if args.object[0].hover!=undefined then hoverClass = args.object[0].hover
  #   if args.object[0].moveonce!=undefined then moveonce = args.object[0].moveonce
  #
  #   if args.object[0].moveonce!=undefined then moveonce = args.object[0].moveonce
  #   if args.object[0].moveonce!=undefined then moveonce = args.object[0].moveonce
  #   if args.object[0].moveonce!=undefined then moveonce = args.object[0].moveonce
  if args.object[0] then opts = args.object[0]; else opts={}
  opts.options=options
  opts.duration=duration


  subject.addClass('olympclickable')

  OLYMP.drag.__storage[args.string[0]] = opts
  # OLYMP.drag.__storage[args.string[0]] = {
  #   options:options ,
  #   duration:duration,
  #   cb1:cb1,
  #   cb2:cb2,
  #   beforeStart:beforeStart,
  #   onStart:onStart,
  #   onMove:onMove,
  #   moveonce: moveonce,
  #   finish: finish,
  #   in: in,
  #   out: out,
  #   hover:hoverClass
  # }





  $(document).on "mousedown touchstart", subject.selector, (event) ->
  # subject.on "touchstart mousedown", (event) ->
    event.preventDefault()



    group = $(this).attr('draggroup')
    if !OLYMP.drag.currentDrag

      OLYMP.event = event
      OLYMP.obj = $(this)

      continuedrag = true

      # if OLYMP.drag.__storage[group].beforestart then continuedrag = OLYMP.drag.__storage[group].beforestart()
      continuedrag = OLYMP.__runcb OLYMP.drag.__storage[group].beforestart
      # console.warn continuedrag
      if continuedrag==false then return false

      if !options.nozindex then OLYMP.obj.css('z-index',9999)


      if event.type=='mousedown'
        eventer = event.originalEvent
      else
        eventer = event.originalEvent.touches[0]

      OLYMP.drag.currentDrag = {group:group, obj:$(this) , pagex:eventer['pageX'] , pagey:eventer['pageY'] , thisx:$(this).position().left, thisy:$(this).position().top , runonce:true         }

      # $('[storing="'+OLYMP.obj.attr('itemid')+'"]').attr('storing','')
      OLYMP.drag.slots = {}
      OLYMP.drag.slotcoordinates = []
      opt = ''
      if !options.filled && !options.exchange then opt = '[storing=""]'
      OLYMP.drag.slots = $('.scene').find('[slotid][draggroup="'+group+'"]'+opt+',[slotid][draggroup="'+group+'"][storing="'+OLYMP.obj.attr('itemid')+'"]')
      # console.log OLYMP.drag.slots;

      for i in [0...OLYMP.drag.slots.length]
        OLYMP.drag.slotcoordinates.push(  OLYMP.__getCoordinates OLYMP.drag.slots.eq(i) )

      # console.log OLYMP.drag.slotcoordinates;




      # if OLYMP.drag.__storage[group].start then OLYMP.drag.__storage[group].start()
      OLYMP.__runcb OLYMP.drag.__storage[group].start
    return false;





  $(document).on "touchmove mousemove", OLYMP.AT.place, (event) ->
  # $(OLYMP.AT.place).on "touchmove mousemove", (event) ->
    if(OLYMP.drag.currentDrag)
      event.preventDefault()
      event.stopPropagation()
      OLYMP.event = event

      # console.log OLYMP.drag.currentDrag

      CDrug = OLYMP.drag.currentDrag
      ths = CDrug.obj
      group = CDrug.group
      options = OLYMP.drag.__storage[group].options
      if event.type=='mousemove'
        eventer = event.originalEvent
      else
        eventer = event.originalEvent.touches[0]

      if options.direction!='y'
        newX = +CDrug.thisx+(eventer['pageX']-CDrug.pagex)
      if options.direction!='x'
        newY = +CDrug.thisy+(eventer['pageY']-CDrug.pagey)

      if options.step
        if options.step==true then step=20; else step=+options.step
        newX = (+(Math.floor(newX/+step))+(Math.round(newX%step/step)))*step
        newY = (+(Math.floor(newY/+step))+(Math.round(newY%step/step)))*step

      if options.capped
        newX = Math.max(0, Math.min((ths.parent().outerWidth()-ths.outerWidth()),newX))
        newY = Math.max(0, Math.min((ths.parent().outerHeight()-ths.outerHeight()),newY))

      ths.css({'left':newX,'top':newY})

      target = OLYMP.__getDragTarget()
      # if target==null then $('[slotid]').removeClass(OLYMP.drag.__storage[group].hover) else target.addClass(OLYMP.drag.__storage[group].hover)
      $('[slotid]').removeClass(OLYMP.drag.__storage[group].hover)
      if target!=null then target.addClass(OLYMP.drag.__storage[group].hover)

      OLYMP.targetSlot = target

      # if OLYMP.isDragging[6] then OLYMP.isDragging[6]()
      # if OLYMP.drag.__storage[group].move then OLYMP.drag.__storage[group].move()

      if CDrug.runonce
        OLYMP.__runcb OLYMP.drag.__storage[group].moveonce
        CDrug.runonce = false

      OLYMP.__runcb OLYMP.drag.__storage[group].move





  $(document).on "mouseleave", OLYMP.AT.place, (event) -> OLYMP.__dragFinishing(event)
  $(document).on "touchend mouseup", OLYMP.AT.place, (event) -> OLYMP.__dragFinishing()
  # $(OLYMP.AT.place).on "mouseleave", (event) -> OLYMP.__dragFinishing()
  # $(OLYMP.AT.place).on "touchend mouseup", (event) -> OLYMP.__dragFinishing()




  OLYMP.__dragFinishing = (event) ->
    if(OLYMP.drag.currentDrag)

      OLYMP.event = event


      # OLYMP.__runcb storage.beforefinish
      # continuedrag = true
      #
      # # if OLYMP.drag.__storage[group].beforestart then continuedrag = OLYMP.drag.__storage[group].beforestart()
      # continuedrag = OLYMP.__runcb OLYMP.drag.__storage[group].beforestart
      # # console.warn continuedrag
      # if continuedrag==false then return false

      CDrug = OLYMP.drag.currentDrag
      target = OLYMP.__getDragTarget()
      OLYMP.targetSlot = target
      obj = CDrug.obj
      group = CDrug.group

      storage = OLYMP.drag.__storage[group]

      # options = OLYMP.drag.__storage[group].options
      # duration = OLYMP.drag.__storage[group].duration
      # cb1 = OLYMP.drag.__storage[group].cb1
      # cb2 = OLYMP.drag.__storage[group].cb2
      exchangerslot = OLYMP.drag.currentDrag.exchangerslot
      delete OLYMP.drag.currentDrag

      OLYMP.drag.slots = {}
      OLYMP.drag.slotcoordinates = []

      $('[slotid]').removeClass(OLYMP.drag.__storage[group].hover)

      if target==null
        if !storage.options.free
          # OLYMP.__moveToInitPosition(obj, storage.duration, cb1)
          OLYMP.__moveToInitPosition(obj, storage.duration, storage.finish, storage.out)
        else
          obj.attr({'init_x':obj.position().left,'init_y':obj.position().top})
          $('[storing="'+obj.attr('itemid')+'"]').attr('storing','')
          # if cb1 then cb1()
          OLYMP.__runcb storage.finish
          OLYMP.__runcb storage.out

      else

        prevslot = exchangerslot
        if exchangerslot then prevslot = exchangerslot
        else prevslot=null

        prevobj = $('[itemid="'+target.attr('storing')+'"]')
        if prevobj.length==0 then prevobj=null

        if prevobj!=null && obj.get(0)!=prevobj.get(0)
          if prevslot==null || storage.options.filled
            OLYMP.__moveToInitPosition(prevobj, storage.duration)
          else
            if storage.options.exchange
              if prevslot.length==1
                OLYMP.__moveToSlot(prevobj,prevslot,storage.duration)
              else
                OLYMP.__moveToInitPosition(prevobj, storage.duration)


        # OLYMP.__moveToSlot(obj,target,storage.duration,cb2)
        OLYMP.__moveToSlot(obj,target,storage.duration,storage.finish,storage.in)






















# INNER METHODS
OLYMP.__moveToSlot = (item, slot, duration, cbfinish=null, cb=null) ->
  $('[storing="'+item.attr('itemid')+'"]').attr('storing','')
  slot.attr('storing',item.attr('itemid'))
  px = slot.outerWidth() - item.outerWidth()
  py = slot.outerHeight() - item.outerHeight()
  OLYMP.animate item, {'left':(slot.position().left + px/+2),'top':(slot.position().top+py/+2)}, duration, =>
    OLYMP.obj.css('z-index',"")
    OLYMP.drag.slot = slot
    # if cb!=null then cb()
    OLYMP.__runcb cbfinish
    OLYMP.__runcb cb


OLYMP.__moveToInitPosition = (item, duration, cbfinish=null, cb=null) ->
  $('[storing="'+item.attr('itemid')+'"]').attr('storing','')
  OLYMP.animate item, {'left':item.attr('init_x'),'top':item.attr('init_y')}, duration, =>
    OLYMP.obj.css('z-index',"")
    OLYMP.drag.slot = null
    # if cb!=null then cb()
    OLYMP.__runcb cbfinish
    OLYMP.__runcb cb



OLYMP.getSlotValues = () ->
  total = {}
  slots = $('[slotid]')
  for i in [0...slots.length]
    currentslot = slots.eq(i)
    if currentslot.attr('storing')==''
      vall = null
    else
      vall = currentslot.attr('storing')
    if total[currentslot.attr('draggroup')]==undefined then total[currentslot.attr('draggroup')] = {}
    total[currentslot.attr('draggroup')][currentslot.attr('slotid')] = vall
  total




OLYMP.setSlotValues = () ->
  data = arguments[0]
  groups = Object.keys(data)
  for group in groups
    slotnames = Object.keys data[group]
    for slotname in slotnames
      slot = $('[draggroup="'+group+'"][slotid="'+slotname+'"]')
      if data[group][slotname]!=null
        item = $('[draggroup="'+group+'"][itemid="'+data[group][slotname]+'"]')
        slot.attr('storing',item.attr('itemid'))
        px = slot.outerWidth() - item.outerWidth()
        py = slot.outerHeight() - item.outerHeight()
        item.css {'left':(slot.position().left + px/+2),'top':(slot.position().top+py/+2)}
      else
        if slot.attr('storing')!=''
          item = $('[draggroup="'+group+'"][itemid="'+slot.attr('storing')+'"]')
          slot.attr('storing','')
          item.css {left:+item.attr('init_x'),top:+item.attr('init_y')}











# OLYMP.__getDragTarget = () ->
#   if !OLYMP.drag.currentDrag then return false
#   group = OLYMP.drag.currentDrag.group
#   options = OLYMP.drag.__storage[group].options
#   opt = ''
#   if !options.filled && !options.exchange then opt = '[storing=""]'
#
#   validSlots = $('.scene').find('[slotid][draggroup="'+group+'"]'+opt+',[slotid][draggroup="'+group+'"][storing="'+OLYMP.obj.attr('itemid')+'"]')
#
#   target = null
#   square = 0
#   # $('[slotid]').removeClass('hoverer')
#
#   for i in [0...validSlots.length]
#     currslot = validSlots.eq(i)
#     tmpsquare = OLYMP.__getIntersects OLYMP.drag.currentDrag.obj, currslot
#     if tmpsquare > square
#       square = tmpsquare
#       target = currslot
#   # if target!=null
#     # target.addClass('hoverer')
#   return target






OLYMP.__getDragTarget = () ->
  if !OLYMP.drag.currentDrag then return false
  group = OLYMP.drag.currentDrag.group
  options = OLYMP.drag.__storage[group].options
  opt = ''
  if !options.filled && !options.exchange then opt = '[storing=""]'

  # validSlots = $('.scene').find('[slotid][draggroup="'+group+'"]'+opt+',[slotid][draggroup="'+group+'"][storing="'+OLYMP.obj.attr('itemid')+'"]')

  target = null
  square = 0
  # $('[slotid]').removeClass('hoverer')

  mycoords = OLYMP.__getCoordinates OLYMP.obj

  for currslot,i in OLYMP.drag.slotcoordinates
    # currslot = OLYMP.drag.slotcoordinates.eq(i)

    w = Math.min(mycoords.x2, currslot.x2) - Math.max(mycoords.x1, currslot.x1)
    h = Math.min(mycoords.y2, currslot.y2) - Math.max(mycoords.y1, currslot.y1)
    Interseption = Math.max(0, w) * Math.max(0, h)

    if Interseption > square
      square = Interseption
      target = OLYMP.drag.slots.eq(i)


    # tmpsquare = OLYMP.__getIntersects OLYMP.drag.currentDrag.obj, currslot
    # if tmpsquare > square
    #   square = tmpsquare
    #   target = currslot
  # if target!=null
    # target.addClass('hoverer')
  return target










OLYMP.__getCoordinates = (obj) ->
  coord = {
    x1: $(obj).position().left
    y1: $(obj).position().top
    x2: $(obj).position().left + $(obj).outerWidth()
    y2: $(obj).position().top + $(obj).outerHeight()
  }
  coord


# OLYMP.__getIntersects = (obj1, obj2) ->
#   obj1_coord = OLYMP.__getCoordinates obj1
#   obj2_coord = OLYMP.__getCoordinates obj2
#   w = Math.min(obj1_coord.x2, obj2_coord.x2) - Math.max(obj1_coord.x1, obj2_coord.x1)
#   h = Math.min(obj1_coord.y2, obj2_coord.y2) - Math.max(obj1_coord.y1, obj2_coord.y1)
#   Math.max(0, w) * Math.max(0, h)









































OLYMP.input = {}
#incoming arguments : input, cb1,cb2
OLYMP.input.on = () ->
  args = OLYMP.__parseArguments(arguments)

  OLYMP.__storage.callbackoninputdeactivate=null
  OLYMP.__storage.callbackoninputenter=null

  input = args.subject

  if OLYMP.__storage.activeinput!=null
    OLYMP.input.off()
  input = $(input)
  OLYMP.__storage.activeinput = input


  if args.function[0]!=undefined then OLYMP.__storage.callbackoninputdeactivate=args.function[0]
  if args.function[1]!=undefined then OLYMP.__storage.callbackoninputenter=args.function[1]


  input.addClass('activeinput')
  OLYMP.AT.tutor.keypad_start ['numeric','input'], (char) =>
    OLYMP.char = char
    OLYMP.input.__keypad char


OLYMP.input.off = () ->
  if OLYMP.__storage.activeinput!=null
    OLYMP.__storage.activeinput.removeClass('activeinput')
    OLYMP.__storage.activeinput=null
    OLYMP.AT.tutor.keypad_finish()
    if OLYMP.__storage.callbackoninputdeactivate!=null
      OLYMP.__storage.callbackoninputdeactivate()


OLYMP.input.set = (input,str) ->

  args = OLYMP.__parseArguments(arguments)
  # input = $(input)
  input = args.subject
  str = args.string[0]


  input.removeClass('inputWrong')
  input.html((''+str).substr(0,input.attr('olympdigits'))+'<span></span>')


OLYMP.input.get = (input) ->
  input = $(input)
  str = ''+input.html()
  ans = str.substr(0,str.length-13)
  if ans=='' then return '' else return parseInt(ans)



OLYMP.input.__keypad = (char) ->
  value = ''+OLYMP.input.get(OLYMP.__storage.activeinput)
  if char!='tab'
    if char=='backspace'
      if value.length>0
        OLYMP.input.set OLYMP.__storage.activeinput, value.substr(0,value.length-1)
    else

      if char=='enter'
        OLYMP.input.off()
      else
        if value.length<OLYMP.__storage.activeinput.attr('olympdigits')
          OLYMP.input.set OLYMP.__storage.activeinput, value+char
  if OLYMP.__storage.callbackoninputenter!=null
    OLYMP.__storage.callbackoninputenter()


OLYMP.input.wrong = (input) ->
  input = $(input)
  input.addClass('inputWrong')















































OLYMP.action = {}

OLYMP.action.off = (selector) ->
  OLYMP.__clearEvents(selector)

OLYMP.action.on = () ->
  args = OLYMP.__parseArguments(arguments)
  onStart = onMove = onFinish = null

  if args.function[0]!=undefined then onStart=args.function[0]
  else return false
  # if args.function[1]!=undefined then onMove=args.function[1]
  # if args.function[2]!=undefined then onFinish=args.function[2]
  #
  # if onFinish==null then onFinish=onMove
  if args.function[1]!=undefined then onMove=args.function[1]
  if args.function[2]!=undefined then onFinish=args.function[2]

  if onFinish==null then onFinish=onMove

  target = args.subject || OLYMP.AT.place


  # target.on "touchstart mousedown", (event) ->

    # $(document).on "touchmove mousemove", OLYMP.AT.place, (event) ->
  $(document).on "mousedown touchstart", target.selector, (event) ->

    if args.subject then event.preventDefault()
    OLYMP.obj = $(this)
    OLYMP.event = event
    if event.type=='mousedown' then eventer = event.originalEvent
    else eventer = event.originalEvent.touches[0]

    pgx = Math.floor(eventer['pageX'] - OLYMP.AT.scene.offset().left)
    pgy = Math.floor(eventer['pageY'] - OLYMP.AT.scene.offset().top)

    OLYMP.actiondata = {on:true,startx:pgx,starty:pgy,newx:pgx,newy:pgy}
    if onStart then onStart()


  # $(OLYMP.AT.place).on "touchmove mousemove", (event) ->
  $(document).on "touchmove mousemove", OLYMP.AT.place, (event) ->
    if OLYMP.actiondata.on
      OLYMP.event = event
      if event.type=='mousemove' then eventer = event.originalEvent
      else eventer = event.originalEvent.touches[0]

      OLYMP.actiondata.newx = Math.floor(eventer['pageX'] - OLYMP.AT.scene.offset().left)
      OLYMP.actiondata.newy = Math.floor(eventer['pageY'] - OLYMP.AT.scene.offset().top)
      if onMove then onMove()

  $(OLYMP.AT.place).on "mouseleave", (event) -> OLYMP.__actionFinishing(event)
  $(OLYMP.AT.place).on "touchend mouseup", (event) -> OLYMP.__actionFinishing(event)

  OLYMP.__actionFinishing = (event) ->
    if OLYMP.actiondata.on
      OLYMP.event = event
      OLYMP.actiondata.on = false
      if onFinish then onFinish()









window.onerror = (msg, url, lineNo, columnNo, error) ->
  # console.warn ' ============= '
  # console.warn this.name
  # message = [  'Message: ' + msg,  'URL: ' + url,  'Line: ' + lineNo,  'Column: ' + columnNo,  'Error object: ' + JSON.stringify(error)  ].join(' - ');
  # console.error message
  #
  # console.warn ' ----- ' + msg
  # console.warn ' ----- ' + url+':'+lineNo

  imsg = msg
  if imsg.indexOf(':')>-1 then imsg = imsg.split(':')[1].trim()
  console.error ''
  console.error imsg
  console.error("%cDetails: " + url+':'+lineNo,'color: #1975d1;');

  return true
  # alert(message);





  #..
