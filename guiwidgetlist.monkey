
Import horizon.utilimage
Import horizon.guiwidgetimagebutton
Import horizon.guiwidget
Import horizon.guiscrollbarvertical

Class GuiWidgetList Extends GuiWidget
    Const PADDING:Int = 10

    Field entryHeight:Int

    Field hovered:Object
    Field selected:Object

    Field entries:List<Object>

    Field offsetY:Int
    Field font:BitmapFont

    Field scrollbar:GuiScrollbarVertical

    Method New()
        selected = Null
        hovered = Null
        rect.w = 500
        rect.h = 340
        rect.x = 100
        rect.y = 100
        entries = New List<Object>

        entryHeight = TextHeight() + PADDING

        scrollbar = New GuiScrollbarVertical
        AddChild(scrollbar)
    End Method

    Method UpdateScrollbar()
        scrollbar.rect.x = rect.x + rect.w - scrollbar.rect.w
        scrollbar.rect.y = rect.y
        scrollbar.SetWidgetHeight(rect.h)
        scrollbar.minValue = 0
        scrollbar.currValue = scrollbar.minValue
        scrollbar.maxValue = Max(0, Int(GetListHeight() - GetDisplayHeight())) / GetDisplayHeight()
        scrollbar.UpdateScrollbarButtons()
        If (GetDisplayHeight() >= GetListHeight())
            scrollbar.Hide()
        Else
            scrollbar.Show()
        End If
    End Method

    Method AddEntry(s:Object)
        entries.AddLast(s)
    End Method

    Method ClearEntries()
        entries.Clear()
    End Method

    Method Update()
        offsetY = GetDisplayHeight() * scrollbar.GetValue()

        If (InputControllerMouse.GetInstance().GetMouseWheel() <> 0 And widgetState = HOVER)
            scrollbar.MoveBar(-InputControllerMouse.GetInstance().GetMouseWheel() * scrollbar.GetBarHeight() / 150)
            OnMouseMove(0,0)
        End If
    End Method

    Method Render()
        UpdateScrollbar()
        Local y:Float = rect.y - offsetY + PADDING / 2
        Local w:Float = rect.w
        If (scrollbar.visible) Then w -= scrollbar.rect.w
''        SetViewport(rect.x, rect.y, w, rect.h)
        SetColor(0, 0, 0)
        SetAlpha(0.4)
        DrawRect(rect.x, rect.y, w, rect.h)
        SetAlpha(1)
        SetColor(255, 255, 255)
        Local bx:Int, by:Int, bw:Int, bh:Int

        entryHeight = TextHeight() + PADDING

        Local key:Int = 0
        For Local obj:Object = EachIn entries
            Local value:String = "String(obj)"
            bx = rect.x
            by = y - PADDING / 2
            bw = w
            bh = entryHeight

            If (selected = obj)
                SetAlpha(0.5)
                DrawRect bx, by, bw, bh
            Else If (hovered = obj)
                SetAlpha(0.25)
                DrawRect bx, by, bw, bh
            End If
            SetAlpha(1)
            font.DrawText(value, bx + PADDING, by + PADDING / 2)
            y += entryHeight
            key += 1
        Next
''        SetViewport(0, 0, VirtualResolutionWidth(), VirtualResolutionHeight())
    End Method

    Method GetDisplayHeight:Float()
        Return rect.h
    End Method

    Method GetListHeight:Float()
        Return entries.Count() * entryHeight
    End Method

    Method OnMouseOver()
        Super.OnMouseOver()
        OnMouseMove(0, 0)
    End Method

    Method OnMouseMove(dx:Int, dy:Int)
        Super.OnMouseMove(dx, dy)
        Local hoveredId:Int = (InputControllerMouse.GetInstance().GetY() + offsetY - rect.y) / entryHeight
        If (entries.Count() > hoveredId And hoveredId >= 0)
            Local c% = 0
            For Local e:Object = Eachin entries
                c+=1
                If (c = hoveredId) Then hovered = e
            Next
        Else
            hovered = Null
        End If
    End Method

    Method OnMouseClick()
        Super.OnMouseClick()
        If hovered Then selected = hovered
    End Method

    Method OnMouseOut()
        Super.OnMouseOut()
        hovered = Null
    End Method
End

