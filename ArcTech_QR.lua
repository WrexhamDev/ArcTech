-- ArcTech_QR.lua
ArcTech = ArcTech or {}

function ArcTech:CreateLAMQRCodeRow(parent)
	local size = self.QR_SIZE
	local data = self.QR_DATA

	-- Ensure the row has enough height
	parent:SetHeight(size + 8)

	if not LibQRCode or not LibQRCode.CreateQRControl then
		local lbl = WINDOW_MANAGER:CreateControl(nil, parent, CT_LABEL)
		lbl:SetAnchor(TOPLEFT, parent, TOPLEFT, 0, 0)
		lbl:SetText("|cFF0000LibQRCode missing or not loaded|r")
		parent:SetHeight(24)
		return lbl
	end

	local qr = LibQRCode.CreateQRControl(size, data)
	qr:SetParent(parent)
	qr:ClearAnchors()
	qr:SetAnchor(TOPLEFT, parent, TOPLEFT, 0, 0)

	return qr
end