Import iap.iap
Import product
Import horizon.payment

Class PaymentService

#if TARGET="android"
	Global androidPayment:PaymentWrapper
#end
	Field products:List<PaymentProduct> = New List<PaymentProduct>
	Field bundleId$  'bundle id (apple)
	Field publicKey$ 'public key (android)
    Field serviceStarted? = False

	Method StartService:Void()
#if TARGET="android"
		androidPayment = New PaymentWrapper()
		androidPayment.Init()
        serviceStarted = True
#end

		Local prodIds:List<String> = New List<String>
		For Local p:PaymentProduct = EachIn products
			prodIds.AddLast(p.GetAppleId())
		Next

		InitInAppPurchases(bundleId, prodIds.ToArray());
#if TARGET="android"
		Security.SetPublicKey(publicKey)
#end
	End

	Method SetBundleId:Void(bundleId$)
		Self.bundleId = bundleId
	End

	Method SetPublicKey:Void(k$)
		publicKey = k
	End

	Method AddProduct:Void(p:PaymentProduct)
        If (Not serviceStarted)
    		p.SetService(Self)
	    	products.AddLast(p)
        End
	End

	Method IsPurchaseInProgress?()
#if TARGET="ios"
		Return (isPurchaseInProgress() > 0)
#elseif TARGET="android"
		Return androidPayment.IsPurchaseInProgress()
#else
        Return False
#end
	End
End
