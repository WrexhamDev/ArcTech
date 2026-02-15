-- ArcTech_QR.lua
function CreateQRCode(parent)
	local size = self.QR_SIZE
	local data = self.QR_DATA

	local qr = LibQRCode.CreateQRControl(size, data)
	qr.SetParent(parent)
	qr.ClearAnchors()
	qr.SetAnchor(TOPLEFT, parent, TOPLEFT, 0, 0)

	return qr
end