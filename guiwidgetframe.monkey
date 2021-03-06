Import horizon.utilimage
Import horizon.guiwidget

Class GuiWidgetFrame Extends GuiWidget
    Field topBar : Image
    Field rightBorder : Image
    Field leftBorder : Image
    Field bottomBorder : Image
    Field resizeBottom : Image

    Field startDrag : Bool

    Field style : Int

    Field title : String = "title"
    Field status : String = "status"

    Const STYLE_RESIZE:Int     = %00000001
    Const STYLE_CLOSE:Int      = %00000010
    Const STYLE_DRAG:Int       = %00000100

    Function Create : GuiWidgetFrame(x:Int, y:Int, w:Int = 0, h:Int = 0,style:Int = STYLE_DRAG)
        Local instance : GuiWidgetFrame = New GuiWidgetFrame
        instance.rect.x = x
        instance.rect.y = y
        instance.rect.w = w
        instance.rect.h = h
        instance.style = style
        Return instance
    End Function

    Method New()
        style = STYLE_DRAG
        InitWidget()
    End Method

    Method InitWidget()
        topBar = LoadImage(GuiSystem.SKIN_PATH + "window/topbar.png")
        rightBorder = LoadImage(GuiSystem.SKIN_PATH + "window/rightborder.png")
        leftBorder = LoadImage(GuiSystem.SKIN_PATH + "window/leftborder.png")
        bottomBorder = LoadImage(GuiSystem.SKIN_PATH + "window/bottomborder.png")
        resizeBottom = LoadImage(GuiSystem.SKIN_PATH + "window/bgresize.png")
    End Method

    Method SetInnerWidth(w:Int)
        rect.w = w + ImageWidth(leftBorder) + ImageWidth(rightBorder)
    End Method

    Method SetInnerHeight(h:Int)
        rect.h = h + ImageHeight(topBar) + ImageHeight(bottomBorder) + ImageHeight(resizeBottom)
    End Method

    Method Render()
        DrawTopBar()
        DrawBottomBorder()
        DrawRightBorder()
        DrawLeftBorder()
    End Method

    Method GetX : Int()
        Return rect.x
    End Method

    Method GetY : Int()
        Return rect.y
    End Method

    Method GetInnerWindowX : Int()
        Return GetX() + ImageWidth(leftBorder)
    End Method

    Method GetInnerWindowY : Int()
        Return GetY() + ImageHeight(topBar)
    End Method

    Method GetInnerWidth : Int()
        Return rect.w - ImageWidth(rightBorder) - ImageWidth(leftBorder)
    End Method

    Method GetInnerHeight : Int()
        Return rect.h - ImageHeight(topBar) - ImageHeight(bottomBorder) - ImageHeight(resizeBottom)
    End Method

    Method DrawTopBar()
        UtilImage.DrawRepeated(topBar, GetX(), GetY(), rect.w, ImageHeight(topBar))
'        DrawText (title, GetX() + ((style & STYLE_CLOSE) * closeButton.w) + 2, GetY() + 6)
        DrawText (title, GetX() + 2, GetY() + 6)
    End Method

    Method DrawRightBorder()
        UtilImage.DrawRepeated(rightBorder, GetX() + rect.w - ImageWidth(rightBorder), GetY() + ImageHeight(topBar), ImageWidth(rightBorder), rect.h - ImageHeight(topBar))
    End Method

    Method DrawLeftBorder()
        UtilImage.DrawRepeated(leftBorder, GetX(), GetY() + ImageHeight(topBar), ImageWidth(leftBorder), rect.h - ImageHeight(topBar))
    End Method

    Method DrawBottomBorder()
        UtilImage.DrawRepeated(resizeBottom, GetX(), GetY() + rect.h - ImageHeight(resizeBottom) - ImageHeight(bottomBorder), rect.w, ImageHeight(resizeBottom))
        SetColor($CC,$CC,$CC)
        DrawText (status, GetX() + ImageWidth(leftBorder), GetY() + rect.h - ImageHeight(resizeBottom))
        SetColor($FF,$FF,$FF)
        UtilImage.DrawRepeated(bottomBorder, GetX(), GetY() + rect.h - ImageHeight(bottomBorder), rect.w, ImageHeight(bottomBorder))
    End Method

    Method SetTitle(t : String)
        title = t
    End Method

    Method SetStatus(s : String)
        status = s
    End Method

    Method OnMouseHit()
        If (style & STYLE_DRAG And GuiSystem.mouse.GetX() >= rect.x And GuiSystem.mouse.GetY() >= rect.y And GuiSystem.mouse.GetX() < rect.x + rect.w And GuiSystem.mouse.GetY() < GetInnerWindowY())
            startDrag = True
        End If
    End Method

    Method OnMouseUp()
        Super.OnMouseUp()
        startDrag = False
    End Method

    Method Update()
        Super.Update()
        If startDrag
            OnMove()
            For Local c : GuiBase = EachIn childs
                If GuiWidget(c) Then GuiWidget(c).OnMove()
            Next
        End If
    End Method
End
