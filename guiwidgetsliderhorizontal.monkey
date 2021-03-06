Import horizon.guiwidget
Import horizon.blitzmaxfunctions

Class GuiWidgetSliderHorizontal Extends GuiWidget
    Field sliderPosX:Float
    Field startSlide:Bool

    Field barImage:Image
    Field sliderImage:Image

    Method New()
        SetBarImage(LoadImage(GuiSystem.SKIN_PATH + "slider/slider.png"))
        SetSliderImage(LoadImage(GuiSystem.SKIN_PATH + "slider/knob.png"))
    End Method

    Method SetBarImage(img:Image)
        barImage = img
        rect.w = ImageWidth(barImage)
        rect.h = ImageHeight(barImage)
    End Method

    Method SetSliderImage(img:Image)
        sliderImage = img
        MidHandleImage(sliderImage)
    End Method

    Method Update()
        If Not MouseDown(0) Then startSlide = False
        If (startSlide)
            sliderPosX -= InputControllerMouse.GetInstance().GetDX()
            If (sliderPosX < 0) Then sliderPosX = 0
            If (sliderPosX > rect.w) Then sliderPosX = rect.w
        End If
    End Method

    Method Render()
        If (barImage And sliderImage)
            DrawImage (barImage, rect.x, rect.y)
            DrawImage (sliderImage, rect.x + sliderPosX, rect.y + rect.h / 2)
        Else
            SetColor(255,0,0)
            DrawRect(rect.x, rect.y, rect.w, rect.h)
            SetColor(0,255,0)
            DrawRect(rect.x + sliderPosX - 2, rect.y - 2, 4, rect.h + 4)
            SetColor(255,255,255)
        End If
    End Method

    Method OnMouseDown()
        Super.OnMouseDown()
    End Method

    Method OnMouseHit()
        startSlide = True
        sliderPosX = InputControllerMouse.GetInstance().GetX() - rect.x
        If (sliderPosX < 0) Then sliderPosX = 0
        If (sliderPosX > rect.w) Then sliderPosX = rect.w
    End

    Method OnMouseUp()
        Super.OnMouseUp()
        startSlide = False
    End Method

    Method GetPositionInPercent:Float()
        Return sliderPosX / rect.w * 100.0
    End Method

    Method GetPositionInPixel:Int()
        Return sliderPosX
    End Method

    Method SetPositionInPercent(p:Float)
        sliderPosX = rect.w * p / 100.0
    End Method
End
