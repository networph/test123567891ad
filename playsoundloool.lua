local Library = {
    activeTab = nil,
    sections = {}
}

local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

-- Create BlurEffect instance
local blurEffect = Instance.new("BlurEffect")
blurEffect.Size = 34 -- Adjust the blur intensity
blurEffect.Parent = Lighting
blurEffect.Enabled = true

local function Dragify(frame, parent)
    parent = parent or frame
    local dragging, dragInput, mousePos, framePos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = parent.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            local targetPosition = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)

            -- Use TweenService to smoothly transition to the target position
            TweenService:Create(parent, TweenInfo.new(0.40, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = targetPosition
            }):Play()
        end
    end)
end

function Library:Toggle(value)
    local screenGui = game:GetService("CoreGui"):FindFirstChild("EUPHORIA")
    local avatarGui = game:GetService("CoreGui"):FindFirstChild("AvatarGui")
    if not screenGui or not avatarGui then return end
    local enabled = (type(value) == "boolean" and value) or not screenGui.Enabled
    screenGui.Enabled = enabled
    avatarGui.Enabled = enabled

    -- Toggle blur effect based on GUI visibility
    blurEffect.Enabled = enabled
end

function Library:Window(options)
    options.text = options.text or "EUPHORIA"

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "EUPHORIA"
    screenGui.Parent = game.CoreGui

    -- Container Frame
    local containerFrame = Instance.new("Frame")
    containerFrame.Name = "ContainerFrame"
    containerFrame.Parent = screenGui
    containerFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    containerFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    containerFrame.BackgroundTransparency = 1
    containerFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    containerFrame.Size = UDim2.new(0, 730, 0, 536)

    -- Sidebar
    local sidebar = Instance.new("Frame")
    sidebar.Name = "SideBar"
    sidebar.Parent = containerFrame
    sidebar.BackgroundColor3 = Color3.fromRGB(9, 8, 13)
    sidebar.BackgroundTransparency = 0.2
    sidebar.BorderSizePixel = 0
    sidebar.Size = UDim2.new(0, 217, 1, 0) -- Increased width

    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = UDim.new(0, 8)
    sidebarCorner.Parent = sidebar

    -- Black line to hide rounded corners on the right
    local rightLine = Instance.new("Frame")
    rightLine.Name = "RightLine"
    rightLine.Parent = sidebar
    rightLine.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    rightLine.BorderSizePixel = 0
    rightLine.Position = UDim2.new(0.975, 0, 0, 0) -- Adjusted position to match the new sidebar width
    rightLine.Size = UDim2.new(0, 10, 1, 0)

    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Parent = sidebar
    title.BackgroundColor3 = Color3.fromRGB(234, 239, 245)
    title.BackgroundTransparency = 1
    title.BorderSizePixel = 0
    title.Position = UDim2.new(0.061, 0, 0.05, 0)
    title.Size = UDim2.new(0, 162, 0, 26)
    title.Font = Enum.Font.ArialBold
    title.Text = options.text
    title.TextColor3 = Color3.fromRGB(234, 239, 245)
    title.TextSize = 27
    title.TextWrapped = true

    -- Expires Label Container
    local expiresContainer = Instance.new("Frame")
    expiresContainer.Name = "ExpiresContainer"
    expiresContainer.Parent = sidebar
    expiresContainer.BackgroundTransparency = 1
    expiresContainer.Position = UDim2.new(0.1, 0, 1, -60) -- Adjusted to move it up and right
    expiresContainer.Size = UDim2.new(0.9, -20, 0, 55) -- Adjusted to move right

    -- Player Headshot
    local headshotImage = Instance.new("ImageLabel")
    headshotImage.Name = "HeadshotImage"
    headshotImage.Parent = expiresContainer
    headshotImage.BackgroundTransparency = 0.4
    headshotImage.Size = UDim2.new(0, 38, 0, 38) -- Adjusted size
    headshotImage.Position = UDim2.new(-0.05, 0, 0.5, -26) -- Moved down 1 pixel
    headshotImage.Image = Players:GetUserThumbnailAsync(Players.LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)

    local headshotImageCorner = Instance.new("UICorner")
    headshotImageCorner.CornerRadius = UDim.new(0, 19)
    headshotImageCorner.Parent = headshotImage

    -- Player Display Name
    local displayName = Players.LocalPlayer.DisplayName
    if #displayName > 10 then
        displayName = string.sub(displayName, 1, 7) .. "..."
    end

    local displayNameLabel = Instance.new("TextLabel")
    displayNameLabel.Name = "DisplayNameLabel"
    displayNameLabel.Parent = expiresContainer
    displayNameLabel.BackgroundTransparency = 1
    displayNameLabel.Position = UDim2.new(0, 40, 0, -4) -- Positioned above the expires label
    displayNameLabel.Size = UDim2.new(1, -50, 0.5, 0)
    displayNameLabel.Font = Enum.Font.GothamBold
    displayNameLabel.Text = displayName
    displayNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    displayNameLabel.TextSize = 16
    displayNameLabel.TextXAlignment = Enum.TextXAlignment.Left
    displayNameLabel.TextYAlignment = Enum.TextYAlignment.Center

    -- Expires Label
    local expiresLabel = Instance.new("TextLabel")
    expiresLabel.Name = "ExpiresLabel"
    expiresLabel.Parent = expiresContainer
    expiresLabel.BackgroundTransparency = 1
    expiresLabel.Position = UDim2.new(0, 40, 0.5, -10) -- Moved up further
    expiresLabel.Size = UDim2.new(1, -50, 0.5, 0)
    expiresLabel.Font = Enum.Font.GothamBold -- Set to a bolder font
    expiresLabel.Text = 'Expires: <font color="rgb(168, 180, 245)">Never</font>'
    expiresLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    expiresLabel.TextSize = 13 -- Increased font size
    expiresLabel.TextXAlignment = Enum.TextXAlignment.Left
    expiresLabel.TextYAlignment = Enum.TextYAlignment.Center
    expiresLabel.RichText = true -- Enable rich text formatting

    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Parent = containerFrame
    mainFrame.AnchorPoint = Vector2.new(0, 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(9, 8, 13)
    mainFrame.BackgroundTransparency = 0
    mainFrame.BorderSizePixel = 0
    mainFrame.Position = UDim2.new(0, 197, 0.5, 0)
    mainFrame.Size = UDim2.new(1, -190, 1, 0)

    local mainFrameCorner = Instance.new("UICorner")
    mainFrameCorner.CornerRadius = UDim.new(0, 8)
    mainFrameCorner.Parent = mainFrame

    Dragify(containerFrame)

    self.screenGui = screenGui
    self.sidebar = sidebar
    self.mainFrame = mainFrame
    self.dividerYPosition = 0.25
    self.buttonYPosition = 0.16

    return screenGui
end

function Library:AddDivider(options)
    local section = options.section or "Section"

    local dividerLabel = Instance.new("TextLabel")
    dividerLabel.Name = section .. "Label"
    dividerLabel.Parent = self.sidebar
    dividerLabel.BackgroundTransparency = 1
    dividerLabel.Size = UDim2.new(1, 0, 0, 20)
    dividerLabel.Position = UDim2.new(0.10, 0, self.dividerYPosition, 0)
    dividerLabel.Font = Enum.Font.Gotham
    dividerLabel.Text = section
    dividerLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
    dividerLabel.TextSize = 14
    dividerLabel.TextXAlignment = Enum.TextXAlignment.Left

    self.dividerYPosition = self.dividerYPosition + 0.05
    self.buttonYPosition = self.buttonYPosition + 0.05
end

function Library:AddButton(options)
    local text = options.text or "Button"
    local icon = options.icon or "rbxassetid://3926305904"

    local button = Instance.new("TextButton")
    button.Parent = self.sidebar
    button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundTransparency = 1
    button.Position = UDim2.new(0.05, 0, self.buttonYPosition, 0)
    button.Size = UDim2.new(0.85, 0, 0, 30) -- Reduced width to make it less wide on the right side
    button.Font = Enum.Font.GothamBold
    button.Text = ""
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.TextXAlignment = Enum.TextXAlignment.Left

    -- Add rounded corners to the button
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8) -- Adjust the radius value as needed
    buttonCorner.Parent = button

    local activeBackground = Instance.new("Frame")
    activeBackground.Name = "ActiveBackground"
    activeBackground.Parent = button
    activeBackground.BackgroundColor3 = Color3.fromRGB(168, 180, 245) -- Adjust the color as needed
    activeBackground.BackgroundTransparency = 0.8
    activeBackground.Size = UDim2.new(1.1, -27, 1, 0) -- Adjust size and position to not touch the sides
    activeBackground.Position = UDim2.new(-0.05, 10, 0, 0) -- Adjust position to center the background
    activeBackground.ZIndex = 1
    activeBackground.Visible = false

    local activeBackgroundCorner = Instance.new("UICorner")
    activeBackgroundCorner.CornerRadius = UDim.new(0, 8)
    activeBackgroundCorner.Parent = activeBackground

    local iconImage = Instance.new("ImageLabel")
    iconImage.Parent = button
    iconImage.BackgroundTransparency = 1
    iconImage.Position = UDim2.new(0.05, 0, 0.15, 0)
    iconImage.Size = UDim2.new(0, 20, 0, 20)
    iconImage.Image = icon
    iconImage.ImageColor3 = Color3.fromRGB(168, 180, 245)
    iconImage.ZIndex = 2

    local buttonText = Instance.new("TextLabel")
    buttonText.Parent = button
    buttonText.BackgroundTransparency = 1
    buttonText.Position = UDim2.new(0.3, 0, 0, 0)
    buttonText.Size = UDim2.new(0.7, 0, 1, 0)
    buttonText.Font = Enum.Font.GothamBold
    buttonText.Text = text
    buttonText.TextColor3 = Color3.fromRGB(255, 255, 255)
    buttonText.TextSize = 14
    buttonText.TextXAlignment = Enum.TextXAlignment.Left
    buttonText.ZIndex = 2

    -- Add click effect
    button.MouseButton1Click:Connect(function()
        if Library.activeTab then
            -- Reset the previously active tab's background transparency and color
            TweenService:Create(Library.activeTab, TweenInfo.new(0.2), {
                BackgroundTransparency = 1, -- Make the background transparent
                BackgroundColor3 = Color3.fromRGB(168, 180, 245)
            }):Play()

            -- Reset the previously active tab's icon color
            local previousIcon = Library.activeTab:FindFirstChildWhichIsA("ImageLabel")
            if previousIcon then
                TweenService:Create(previousIcon, TweenInfo.new(0.2), {
                    ImageColor3 = Color3.fromRGB(168, 180, 245)
                }):Play()
            end

            -- Hide active background of the previously active tab
            local previousActiveBackground = Library.activeTab:FindFirstChild("ActiveBackground")
            if previousActiveBackground then
                previousActiveBackground.Visible = false
            end
        end

        -- Set the new active tab and change its background transparency and color
        Library.activeTab = button
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundTransparency = 1, -- Make the background transparent
            BackgroundColor3 = Color3.fromRGB(168, 180, 245)
        }):Play()

        -- Change the active tab's icon color
        local newIcon = button:FindFirstChildWhichIsA("ImageLabel")
        if newIcon then
            TweenService:Create(newIcon, TweenInfo.new(0.2), {
                ImageColor3 = Color3.fromRGB(168, 180, 245) -- Set icon color to a darker color
            }):Play()
        end

        -- Show active background of the new active tab
        activeBackground.Visible = true

        -- Hide all sections
        for _, section in pairs(Library.sections) do
            section.Visible = false
        end

        -- Show sections related to this tab
        if options.sections then
            for _, section in pairs(options.sections) do
                section.Visible = true
            end
        end

        -- Show or hide the "Esp Preview" based on the selected tab
        Library.avatarBox.Visible = true

        if options.callback then
            options.callback()
        end
    end)

    self.buttonYPosition = self.buttonYPosition + 0.06
    self.dividerYPosition = self.dividerYPosition + 0.06
end

function Library:AddSection(options)
    local width = options.width or 150
    local height = options.height or 150
    local position = options.position or "left"

    local sectionFrame = Instance.new("Frame")
    sectionFrame.Name = "SectionFrame"
    sectionFrame.Parent = self.mainFrame
    sectionFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    sectionFrame.BackgroundTransparency = 0.2
    sectionFrame.BorderSizePixel = 0
    sectionFrame.Size = UDim2.new(0, width, 0, height)

    local sectionCorner = Instance.new("UICorner")
    sectionCorner.CornerRadius = UDim.new(0, 8)
    sectionCorner.Parent = sectionFrame

    local sectionLabel = Instance.new("TextLabel")
    sectionLabel.Name = "SectionLabel"
    sectionLabel.Parent = sectionFrame
    sectionLabel.BackgroundTransparency = 1
    sectionLabel.Size = UDim2.new(1, 0, 0, 20)
    sectionLabel.Font = Enum.Font.GothamBold
    sectionLabel.Text = options.text or ""
    sectionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    sectionLabel.TextSize = 14
    sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    sectionLabel.Position = UDim2.new(0.05, 0, 0, 0)

    if position == "left" then
        sectionFrame.Position = UDim2.new(0.05, 0, 0.05, 0)
    elseif position == "right" then
        sectionFrame.Position = UDim2.new(0.95, -width, 0.05, 0)
    elseif position == "top" then
        sectionFrame.Position = UDim2.new(0.5, -width / 2, 0.05, 0)
    elseif position == "bottom" then
        sectionFrame.Position = UDim2.new(0.5, -width / 2, 0.95, -height)
    elseif position == "bottomLeft" then
        sectionFrame.Position = UDim2.new(0.05, 0, 0.95, -height)
    elseif position == "bottomRight" then
        sectionFrame.Position = UDim2.new(0.95, -width, 0.95, -height)
    end

    table.insert(self.sections, sectionFrame)
    sectionFrame.Visible = false

    return sectionFrame
end

function Library:AvatarBox()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AvatarGui"
    screenGui.Parent = game.CoreGui

    local avatarBox = Instance.new("Frame")
    avatarBox.Name = "AvatarBox"
    avatarBox.Parent = screenGui
    avatarBox.AnchorPoint = Vector2.new(0.5, 0.5)
    avatarBox.BackgroundColor3 = Color3.fromRGB(9, 8, 13)
    avatarBox.BackgroundTransparency = 0
    avatarBox.BorderSizePixel = 0
    avatarBox.Position = UDim2.new(0.8, 0, 0.5, 0)
    avatarBox.Size = UDim2.new(0, 290, 0, 496)

    local avatarBoxCorner = Instance.new("UICorner")
    avatarBoxCorner.CornerRadius = UDim.new(0, 8)
    avatarBoxCorner.Parent = avatarBox

    -- Add "Esp Preview" label
    local espPreviewLabel = Instance.new("TextLabel")
    espPreviewLabel.Name = "EspPreviewLabel"
    espPreviewLabel.Parent = avatarBox
    espPreviewLabel.BackgroundTransparency = 1
    espPreviewLabel.Size = UDim2.new(1, 0, 0, 30)
    espPreviewLabel.Position = UDim2.new(0, 0, 0, 0)
    espPreviewLabel.Font = Enum.Font.GothamBold
    espPreviewLabel.Text = "Esp Preview"
    espPreviewLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    espPreviewLabel.TextSize = 14
    espPreviewLabel.TextXAlignment = Enum.TextXAlignment.Center
    espPreviewLabel.TextYAlignment = Enum.TextYAlignment.Center

    local avatar = Instance.new("ImageLabel")
    avatar.Name = "Avatar"
    avatar.Parent = avatarBox
    avatar.AnchorPoint = Vector2.new(0.5, 0.5)
    avatar.BackgroundTransparency = 1
    avatar.Position = UDim2.new(0.5, 0, 0.55, 0) -- Adjusted position to account for the label
    avatar.Size = UDim2.new(1, -20, 0.9, -20) -- Adjusted size to account for the label
    avatar.Image = Players:GetUserThumbnailAsync(Players.LocalPlayer.UserId, Enum.ThumbnailType.AvatarThumbnail, Enum.ThumbnailSize.Size420x420)

    Dragify(avatarBox)

    self.avatarBox = avatarBox
    return screenGui
end

local Window = Library:Window({
    text = "EUPHORIA"
})

local mainSectionLeft = Library:AddSection({
    text = "Main Section Left",
    width = 250,
    height = 220,
    position = "left"
})

local mainSectionRight = Library:AddSection({
    text = "Main Section Right",
    width = 250,
    height = 220,
    position = "right"
})

Library:AddButton({
    text = "Main",
    icon = "rbxassetid://6026568198",
    sections = {mainSectionLeft, mainSectionRight},
    callback = function()
        print("Main button clicked")
    end
})

Library:AddButton({
    text = "Rage",
    icon = "rbxassetid://7999345313",
    callback = function()
        print("Rage button clicked")
    end
})

Library:AddElement(mainSectionLeft, "Button", {
    text = "Click Me",
    callback = function()
        print("Button Clicked!")
    end
})

Library:AddElement(mainSectionRight, "Toggle", {
    text = "Enable Feature",
    state = false,
    callback = function(state)
        print("Toggle State: ", state)
    end
})

Library:AddElement(mainSectionRight, "Slider", {
    text = "Adjust Value",
    min = 0,
    max = 100,
    callback = function(value)
        print("Slider Value: ", value)
    end
})

Library:AddElement(mainSectionLeft, "Dropdown", {
    text = "Choose Option",
    default = "Option 1",
    list = {"Option 1", "Option 2", "Option 3"},
    callback = function(selected)
        print("Selected: ", selected)
    end
})

Library:AddElement(mainSectionLeft, "Textbox", {
    text = "Enter Text",
    value = "Default Text",
    callback = function(text)
        print("Entered Text: ", text)
    end
})

Library:AddElement(mainSectionRight, "Colorpicker", {
    text = "Pick a Color",
    color = Color3.new(1, 0, 0),
    callback = function(color)
        print("Selected Color: ", color)
    end
})

Library:AddElement(mainSectionRight, "Keybind", {
    text = "Press a Key",
    default = Enum.KeyCode.E,
    callback = function(key)
        print("Key Pressed: ", key)
    end
})



local AvatarBox = Library:AvatarBox()

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    if input.KeyCode == Enum.KeyCode.Z then
        Library:Toggle()
    end
end)

function Library:Notify(tt, tx)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = tt,
        Text = tx,
        Duration = 5
    })
end

local function buttoneffect(options)
    pcall(function()
        options.entered.MouseEnter:Connect(function()
            if options.frame.TextColor3 ~= Color3.fromRGB(234, 239, 246) then
                TweenService:Create(options.frame, TweenInfo.new(0.06, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                    TextColor3 = Color3.fromRGB(234, 239, 245)
                }):Play()
            end
        end)
        options.entered.MouseLeave:Connect(function()
            if options.frame.TextColor3 ~= Color3.fromRGB(157, 171, 182) and options.frame.TextColor3 ~= Color3.fromRGB(234, 239, 246) then
                TweenService:Create(options.frame, TweenInfo.new(0.06, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                    TextColor3 = Color3.fromRGB(157, 171, 182)
                }):Play()
            end
        end)
    end)
end

local function clickEffect(options)
    options.button.MouseButton1Click:Connect(function()
        local new = options.button.TextSize - tonumber(options.amount)
        local revert = new + tonumber(options.amount)
        TweenService:Create(options.button, TweenInfo.new(0.15, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {TextSize = new}):Play()
        wait(0.1)
        TweenService:Create(options.button, TweenInfo.new(0.1, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {TextSize = revert}):Play()
    end)
end

function Library:AddElement(section, elementType, options)
    local sectionFrame = section
    if not sectionFrame then
        self:Notify("Element Error", "Section not found!")
        return
    end

    local elements = {}

    function elements:Button(options)
        if not options.text or not options.callback then
            Library:Notify("Button Error", "Missing arguments!")
            return
        end

        local TextButton = Instance.new("TextButton")

        TextButton.Parent = sectionFrame
        TextButton.BackgroundColor3 = Color3.fromRGB(13, 57, 84)
        TextButton.BorderSizePixel = 0
        TextButton.Position = UDim2.new(0.0348837227, 0, 0.355555564, 0)
        TextButton.Size = UDim2.new(0, 200, 0, 22)
        TextButton.AutoButtonColor = false
        TextButton.Text = options.text
        TextButton.Font = Enum.Font.Gotham
        TextButton.TextColor3 = Color3.fromRGB(157, 171, 182)
        TextButton.TextSize = 14.000
        TextButton.BackgroundTransparency = 1
        buttoneffect({frame = TextButton, entered = TextButton})
        clickEffect({button = TextButton, amount = 5})
        TextButton.MouseButton1Click:Connect(function()
            options.callback()
        end)
    end

    function elements:Toggle(options)
        if not options.text or not options.callback then
            Library:Notify("Toggle Error", "Missing arguments!")
            return
        end

        local toggleLabel = Instance.new("TextLabel")
        local toggleFrame = Instance.new("TextButton")
        local togFrameCorner = Instance.new("UICorner")
        local toggleButton = Instance.new("TextButton")
        local togBtnCorner = Instance.new("UICorner")

        local State = options.state or false

        if options.state then
            toggleButton.Position = UDim2.new(0.74, 0, 0.5, 0)
            toggleLabel.TextColor3 = Color3.fromRGB(234, 239, 246)
            toggleButton.BackgroundColor3 = Color3.fromRGB(2, 162, 243)
            toggleFrame.BackgroundColor3 = Color3.fromRGB(2, 23, 49)
        end

        toggleLabel.Name = "toggleLabel"
        toggleLabel.Parent = sectionFrame
        toggleLabel.BackgroundColor3 = Color3.fromRGB(157, 171, 182)
        toggleLabel.BackgroundTransparency = 1.000
        toggleLabel.Position = UDim2.new(0.0348837227, 0, 0.965517223, 0)
        toggleLabel.Size = UDim2.new(0, 200, 0, 22)
        toggleLabel.Font = Enum.Font.Gotham
        toggleLabel.Text = " " .. options.text
        toggleLabel.TextColor3 = Color3.fromRGB(157, 171, 182)
        toggleLabel.TextSize = 14.000
        toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        buttoneffect({frame = toggleLabel, entered = toggleLabel})

        local function PerformToggle()
            State = not State
            options.callback(State)
            TweenService:Create(toggleButton, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {
                Position = State and UDim2.new(0.74, 0, 0.5, 0) or UDim2.new(0.25, 0, 0.5, 0)
            }):Play()
            TweenService:Create(toggleLabel, TweenInfo.new(0.06, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {
                TextColor3 = State and Color3.fromRGB(234, 239, 246) or Color3.fromRGB(157, 171, 182)
            }):Play()
            TweenService:Create(toggleButton, TweenInfo.new(0.06, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {
                BackgroundColor3 = State and Color3.fromRGB(2, 162, 243) or Color3.fromRGB(77, 77, 77)
            }):Play()
            TweenService:Create(toggleFrame, TweenInfo.new(0.06, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {
                BackgroundColor3 = State and Color3.fromRGB(2, 23, 49) or Color3.fromRGB(4, 4, 11)
            }):Play()
        end

        toggleFrame.Name = "toggleFrame"
        toggleFrame.Parent = toggleLabel
        toggleFrame.BackgroundColor3 = Color3.fromRGB(4, 4, 11)
        toggleFrame.BorderSizePixel = 0
        toggleFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        toggleFrame.Position = UDim2.new(0.9, 0, 0.5, 0)
        toggleFrame.Size = UDim2.new(0, 38, 0, 18)
        toggleFrame.AutoButtonColor = false
        toggleFrame.Font = Enum.Font.SourceSans
        toggleFrame.Text = ""
        toggleFrame.TextColor3 = Color3.fromRGB(0, 0, 0)
        toggleFrame.TextSize = 14.000
        toggleFrame.MouseButton1Click:Connect(function()
            PerformToggle()
        end)

        togFrameCorner.CornerRadius = UDim.new(0, 50)
        togFrameCorner.Name = "togFrameCorner"
        togFrameCorner.Parent = toggleFrame

        toggleButton.Name = "toggleButton"
        toggleButton.Parent = toggleFrame
        toggleButton.BackgroundColor3 = Color3.fromRGB(77, 77, 77)
        toggleButton.BorderSizePixel = 0
        toggleButton.AnchorPoint = Vector2.new(0.5, 0.5)
        toggleButton.Position = UDim2.new(0.25, 0, 0.5, 0)
        toggleButton.Size = UDim2.new(0, 16, 0, 16)
        toggleButton.AutoButtonColor = false
        toggleButton.Font = Enum.Font.SourceSans
        toggleButton.Text = ""
        toggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
        toggleButton.TextSize = 14.000
        toggleButton.MouseButton1Click:Connect(function()
            PerformToggle()
        end)

        togBtnCorner.CornerRadius = UDim.new(0, 50)
        togBtnCorner.Name = "togFrameCorner"
        togBtnCorner.Parent = toggleButton
    end

    function elements:Slider(options)
        if not options.text or not options.min or not options.max or not options.callback then
            Library:Notify("Slider Error", "Missing arguments!")
            return
        end

        local Slider = Instance.new("Frame")
        local sliderLabel = Instance.new("TextLabel")
        local sliderFrame = Instance.new("TextButton")
        local sliderBall = Instance.new("TextButton")
        local sliderBallCorner = Instance.new("UICorner")
        local sliderTextBox = Instance.new("TextBox")
        buttoneffect({frame = sliderLabel, entered = Slider})

        local Value
        local Held = false

        local UIS = game:GetService("UserInputService")
        local RS = game:GetService("RunService")
        local Mouse = game.Players.LocalPlayer:GetMouse()

        local percentage = 0
        local step = 0.01

        local function snap(number, factor)
            if factor == 0 then
                return number
            else
                return math.floor(number/factor+0.5)*factor
            end
        end

        UIS.InputEnded:Connect(function(Mouse)
            Held = false
        end)

        Slider.Name = "Slider"
        Slider.Parent = sectionFrame
        Slider.BackgroundColor3 = Color3.fromRGB(157, 171, 182)
        Slider.BackgroundTransparency = 1.000
        Slider.Position = UDim2.new(0.0395348854, 0, 0.947335422, 0)
        Slider.Size = UDim2.new(0, 200, 0, 22)

        sliderLabel.Name = "sliderLabel"
        sliderLabel.Parent = Slider
        sliderLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        sliderLabel.BackgroundColor3 = Color3.fromRGB(157, 171, 182)
        sliderLabel.BackgroundTransparency = 1.000
        sliderLabel.Position = UDim2.new(0.2, 0, 0.5, 0)
        sliderLabel.Size = UDim2.new(0, 77, 0, 22)
        sliderLabel.Font = Enum.Font.Gotham
        sliderLabel.Text = " " .. options.text
        sliderLabel.TextColor3 = Color3.fromRGB(157, 171, 182)
        sliderLabel.TextSize = 14.000
        sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        sliderLabel:GetPropertyChangedSignal("TextBounds"):Connect(function()
            if sliderLabel.TextBounds.X > 75 then
                sliderLabel.TextScaled = true
            else
                sliderLabel.TextScaled = false
            end
        end)

        sliderFrame.Name = "sliderFrame"
        sliderFrame.Parent = sliderLabel
        sliderFrame.BackgroundColor3 = Color3.fromRGB(29, 87, 118)
        sliderFrame.BorderSizePixel = 0
        sliderFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        sliderFrame.Position = UDim2.new(1.6, 0, 0.5, 0)
        sliderFrame.Size = UDim2.new(0, 72, 0, 2)
        sliderFrame.Text = ""
        sliderFrame.AutoButtonColor = false
        sliderFrame.MouseButton1Down:Connect(function()
            Held = true
        end)

        sliderBall.Name = "sliderBall"
        sliderBall.Parent = sliderFrame
        sliderBall.AnchorPoint = Vector2.new(0.5, 0.5)
        sliderBall.BackgroundColor3 = Color3.fromRGB(67, 136, 231)
        sliderBall.BorderSizePixel = 0
        sliderBall.Position = UDim2.new(0, 0, 0.5, 0)
        sliderBall.Size = UDim2.new(0, 14, 0, 14)
        sliderBall.AutoButtonColor = false
        sliderBall.Font = Enum.Font.SourceSans
        sliderBall.Text = ""
        sliderBall.TextColor3 = Color3.fromRGB(0, 0, 0)
        sliderBall.TextSize = 14.000
        sliderBall.MouseButton1Down:Connect(function()
            Held = true
        end)

        RS.RenderStepped:Connect(function()
            if Held then
                local BtnPos = sliderBall.Position
                local MousePos = UIS:GetMouseLocation().X
                local FrameSize = sliderFrame.AbsoluteSize.X
                local FramePos = sliderFrame.AbsolutePosition.X
                local pos = snap((MousePos-FramePos)/FrameSize,step)
                percentage = math.clamp(pos,0,0.9)

                Value = ((((tonumber(options.max) - tonumber(options.min)) / 0.9) * percentage)) + tonumber(options.min)
                Value = math.clamp(Value, options.min, options.max)
                sliderTextBox.Text = Value
                options.callback(Value)
                sliderBall.Position = UDim2.new(percentage,0,BtnPos.Y.Scale, BtnPos.Y.Offset)
            end
        end)

        sliderBallCorner.CornerRadius = UDim.new(0, 50)
        sliderBallCorner.Name = "sliderBallCorner"
        sliderBallCorner.Parent = sliderBall

        sliderTextBox.Name = "sliderTextBox"
        sliderTextBox.Parent = sliderLabel
        sliderTextBox.BackgroundColor3 = Color3.fromRGB(1, 7, 17)
        sliderTextBox.AnchorPoint = Vector2.new(0.5, 0.5)
        sliderTextBox.Position = UDim2.new(2.4, 0, 0.5, 0)
        sliderTextBox.Size = UDim2.new(0, 31, 0, 15)
        sliderTextBox.Font = Enum.Font.Gotham
        sliderTextBox.Text = options.min
        sliderTextBox.TextColor3 = Color3.fromRGB(234, 239, 245)
        sliderTextBox.TextSize = 11.000
        sliderTextBox.TextWrapped = true

        sliderTextBox.Focused:Connect(function()
            TweenService:Create(sliderLabel, TweenInfo.new(0.06, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {TextColor3 = Color3.fromRGB(234, 239, 246)}):Play()
        end)

        sliderTextBox.FocusLost:Connect(function(Enter)
            TweenService:Create(sliderLabel, TweenInfo.new(0.06, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {TextColor3 = Color3.fromRGB(157, 171, 182)}):Play()
            if Enter then
                if sliderTextBox.Text ~= nil and sliderTextBox.Text ~= "" then
                    if tonumber(sliderTextBox.Text) > options.max then
                        sliderTextBox.Text = tostring(options.max)
                        options.callback(options.max)
                    elseif tonumber(sliderTextBox.Text) < options.min then
                        sliderTextBox.Text = tostring(options.min)
                        options.callback(options.min)
                    elseif not tonumber(sliderTextBox.Text) < options.min and not tonumber(sliderTextBox.Text) > options.max then
                        options.callback(sliderTextBox.Text)
                    end
                end
            end
        end)
    end

    function elements:Dropdown(options)
        if not options.text or not options.default or not options.list or not options.callback then
            Library:Notify("Dropdown Error", "Missing arguments!")
            return
        end

        local DropYSize = 0
        local Dropped = false

        local Dropdown = Instance.new("Frame")
        local dropdownLabel = Instance.new("TextLabel")
        local dropdownText = Instance.new("TextLabel")
        local dropdownArrow = Instance.new("ImageButton")
        local dropdownList = Instance.new("Frame")

        local dropListLayout = Instance.new("UIListLayout")
        buttoneffect({frame = dropdownLabel, entered = Dropdown})

        Dropdown.Name = "Dropdown"
        Dropdown.Parent = sectionFrame
        Dropdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Dropdown.BackgroundTransparency = 1.000
        Dropdown.BorderSizePixel = 0
        Dropdown.Position = UDim2.new(0.0697674453, 0, 0.237037033, 0)
        Dropdown.Size = UDim2.new(0, 200, 0, 22)
        Dropdown.ZIndex = 2

        dropdownLabel.Name = "dropdownLabel"
        dropdownLabel.Parent = Dropdown
        dropdownLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        dropdownLabel.BackgroundTransparency = 1.000
        dropdownLabel.BorderSizePixel = 0
        dropdownLabel.Size = UDim2.new(0, 105, 0, 22)
        dropdownLabel.Font = Enum.Font.Gotham
        dropdownLabel.Text = " " .. options.text
        dropdownLabel.TextColor3 = Color3.fromRGB(157, 171, 182)
        dropdownLabel.TextSize = 14.000
        dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
        dropdownLabel.TextWrapped = true

        dropdownText.Name = "dropdownText"
        dropdownText.Parent = dropdownLabel
        dropdownText.BackgroundColor3 = Color3.fromRGB(2, 5, 12)
        dropdownText.Position = UDim2.new(1.08571434, 0, 0.0909090936, 0)
        dropdownText.Size = UDim2.new(0, 87, 0, 18)
        dropdownText.Font = Enum.Font.Gotham
        dropdownText.Text = " " .. options.default
        dropdownText.TextColor3 = Color3.fromRGB(234, 239, 245)
        dropdownText.TextSize = 12.000
        dropdownText.TextXAlignment = Enum.TextXAlignment.Left
        dropdownText.TextWrapped = true

        dropdownArrow.Name = "dropdownArrow"
        dropdownArrow.Parent = dropdownText
        dropdownArrow.BackgroundColor3 = Color3.fromRGB(2, 5, 12)
        dropdownArrow.BorderSizePixel = 0
        dropdownArrow.Position = UDim2.new(0.87356323, 0, 0.138888866, 0)
        dropdownArrow.Size = UDim2.new(0, 11, 0, 13)
        dropdownArrow.AutoButtonColor = false
        dropdownArrow.Image = "rbxassetid://8008296380"
        dropdownArrow.ImageColor3 = Color3.fromRGB(157, 171, 182)

        dropdownArrow.MouseButton1Click:Connect(function()
            Dropped = not Dropped
            if Dropped then
                if dropdownLabel.TextColor3 ~= Color3.fromRGB(234, 239, 245) then
                    TweenService:Create(dropdownLabel, TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                        TextColor3 = Color3.fromRGB(234, 239, 246)
                    }):Play()
                end
                TweenService:Create(dropdownList, TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    Size = UDim2.new(0, 87, 0, DropYSize)
                }):Play()
                TweenService:Create(dropdownList, TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    BorderSizePixel = 1
                }):Play()
            elseif not Dropped then
                if dropdownLabel.TextColor3 ~= Color3.fromRGB(157, 171, 182) then
                    TweenService:Create(dropdownLabel, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                        TextColor3 = Color3.fromRGB(157, 171, 182)
                    }):Play()
                end
                TweenService:Create(dropdownList, TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    Size = UDim2.new(0, 87, 0, 0)
                }):Play()
                TweenService:Create(dropdownList, TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    BorderSizePixel = 0
                }):Play()
            end
        end)

        dropdownList.Name = "dropdownList"
        dropdownList.Parent = dropdownText
        dropdownList.BackgroundColor3 = Color3.fromRGB(2, 5, 12)
        dropdownList.Position = UDim2.new(0, 0, 1, 0)
        dropdownList.Size = UDim2.new(0, 87, 0, 0)
        dropdownList.ClipsDescendants = true
        dropdownList.BorderSizePixel = 0
        dropdownList.ZIndex = 10

        dropListLayout.Name = "dropListLayout"
        dropListLayout.Parent = dropdownList
        dropListLayout.SortOrder = Enum.SortOrder.LayoutOrder

        for i,v in next, options.list do
            local dropdownBtn = Instance.new("TextButton")
            local Count = 1

            dropdownBtn.Name = "dropdownBtn"
            dropdownBtn.Parent = dropdownList
            dropdownBtn.BackgroundColor3 = Color3.fromRGB(234, 239, 245)
            dropdownBtn.BackgroundTransparency = 1.000
            dropdownBtn.BorderSizePixel = 0
            dropdownBtn.Position = UDim2.new(-0.0110929646, 0, 0.0305557251, 0)
            dropdownBtn.Size = UDim2.new(0, 87, 0, 18)
            dropdownBtn.AutoButtonColor = false
            dropdownBtn.Font = Enum.Font.Gotham
            dropdownBtn.TextColor3 = Color3.fromRGB(234, 239, 245)
            dropdownBtn.TextSize = 12.000
            dropdownBtn.Text = v
            dropdownBtn.ZIndex = 15
            clickEffect({button = dropdownBtn, amount = 5})

            Count = Count + 1
            dropdownList.ZIndex -= Count
            DropYSize = DropYSize + 18

            dropdownBtn.MouseButton1Click:Connect(function()
                dropdownText.Text = " " .. v
                options.callback(v)
            end)
        end
    end

    function elements:Textbox(options)
        if not options.text or not options.value or not options.callback then
            Library:Notify("Textbox Error", "Missing arguments!")
            return
        end

        local Textbox = Instance.new("Frame")
        local textBoxLabel = Instance.new("TextLabel")
        local textBox = Instance.new("TextBox")

        Textbox.Name = "Textbox"
        Textbox.Parent = sectionFrame
        Textbox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Textbox.BackgroundTransparency = 1.000
        Textbox.BorderSizePixel = 0
        Textbox.Position = UDim2.new(0.0348837227, 0, 0.945454538, 0)
        Textbox.Size = UDim2.new(0, 200, 0, 22)
        buttoneffect({frame = textBoxLabel, entered = Textbox})

        textBoxLabel.Name = "textBoxLabel"
        textBoxLabel.Parent = Textbox
        textBoxLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        textBoxLabel.BackgroundColor3 = Color3.fromRGB(157, 171, 182)
        textBoxLabel.BackgroundTransparency = 1.000
        textBoxLabel.Position = UDim2.new(0.237000003, 0, 0.5, 0)
        textBoxLabel.Size = UDim2.new(0, 99, 0, 22)
        textBoxLabel.Font = Enum.Font.Gotham
        textBoxLabel.Text = "  " .. options.text
        textBoxLabel.TextColor3 = Color3.fromRGB(157, 171, 182)
        textBoxLabel.TextSize = 14.000
        textBoxLabel.TextXAlignment = Enum.TextXAlignment.Left

        textBox.Name = "textBox"
        textBox.Parent = Textbox
        textBox.AnchorPoint = Vector2.new(0.5, 0.5)
        textBox.BackgroundColor3 = Color3.fromRGB(1, 7, 17)
        textBox.Position = UDim2.new(0.850000024, 0, 0.5, 0)
        textBox.Size = UDim2.new(0, 53, 0, 15)
        textBox.Font = Enum.Font.Gotham
        textBox.Text = options.value
        textBox.TextColor3 = Color3.fromRGB(234, 239, 245)
        textBox.TextSize = 11.000
        textBox.TextWrapped = true

        textBox.Focused:Connect(function()
            TweenService:Create(textBoxLabel, TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextColor3 = Color3.fromRGB(234, 239, 246)}):Play()
        end)

        textBox.FocusLost:Connect(function(Enter)
            TweenService:Create(textBoxLabel, TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextColor3 = Color3.fromRGB(157, 171, 182)}):Play()
            if Enter then
                if textBox.Text ~= nil and textBox.Text ~= "" then
                    options.callback(textBox.Text)
                end
            end
        end)
    end

    function elements:Colorpicker(options)
        if not options.text or not options.color or not options.callback then
            Library:Notify("Colorpicker Error", "Missing arguments!")
            return
        end

        local hue, sat, val = Color3.toHSV(options.color)

        local Colorpicker = Instance.new("Frame")
        local colorpickerLabel = Instance.new("TextLabel")
        local colorpickerButton = Instance.new("ImageButton")
        local colorpickerFrame = Instance.new("Frame")
        local RGB = Instance.new("ImageButton")
        local RGBCircle = Instance.new("ImageLabel")
        local Darkness = Instance.new("ImageButton")
        local DarknessCircle = Instance.new("Frame")
        local colorHex = Instance.new("TextLabel")
        local Copy = Instance.new("TextButton")
        buttoneffect({frame = colorpickerLabel, entered = Colorpicker})

        local vis = false

        Colorpicker.Name = "Colorpicker"
        Colorpicker.Parent = sectionFrame
        Colorpicker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Colorpicker.BackgroundTransparency = 1.000
        Colorpicker.BorderSizePixel = 0
        Colorpicker.Position = UDim2.new(0.0348837227, 0, 0.945454538, 0)
        Colorpicker.Size = UDim2.new(0, 200, 0, 22)
        Colorpicker.ZIndex = 2

        colorpickerLabel.Name = "colorpickerLabel"
        colorpickerLabel.Parent = Colorpicker
        colorpickerLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        colorpickerLabel.BackgroundColor3 = Color3.fromRGB(157, 171, 182)
        colorpickerLabel.BackgroundTransparency = 1.000
        colorpickerLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
        colorpickerLabel.Size = UDim2.new(0, 200, 0, 22)
        colorpickerLabel.Font = Enum.Font.Gotham
        colorpickerLabel.Text = " " .. options.text
        colorpickerLabel.TextColor3 = Color3.fromRGB(157, 171, 182)
        colorpickerLabel.TextSize = 14.000
        colorpickerLabel.TextXAlignment = Enum.TextXAlignment.Left

        colorpickerButton.Name = "colorpickerButton"
        colorpickerButton.Parent = colorpickerLabel
        colorpickerButton.AnchorPoint = Vector2.new(0.5, 0.5)
        colorpickerButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        colorpickerButton.BackgroundTransparency = 1.000
        colorpickerButton.BorderSizePixel = 0
        colorpickerButton.Position = UDim2.new(0.920, 0, 0.57, 0)
        colorpickerButton.Size = UDim2.new(0, 15, 0, 15)
        colorpickerButton.Image = "rbxassetid://8023491332"
        colorpickerButton.MouseButton1Click:Connect(function()
            colorpickerFrame.Visible = not colorpickerFrame.Visible
            vis = not vis
            TweenService:Create(colorpickerLabel, TweenInfo.new(0.06, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {
                TextColor3 = vis and Color3.fromRGB(234, 239, 246) or Color3.fromRGB(157, 171, 182)
            }):Play()
        end)

        colorpickerFrame.Name = "colorpickerFrame"
        colorpickerFrame.Parent = Colorpicker
        colorpickerFrame.Visible = false
        colorpickerFrame.BackgroundColor3 = Color3.fromRGB(0, 10, 21)
        colorpickerFrame.Position = UDim2.new(1.15, 0, 0.5, 0)
        colorpickerFrame.Size = UDim2.new(0, 251, 0, 221)
        colorpickerFrame.ZIndex = 15
        Dragify(colorpickerFrame, Colorpicker)

        RGB.Name = "RGB"
        RGB.Parent = colorpickerFrame
        RGB.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        RGB.BackgroundTransparency = 1.000
        RGB.BorderSizePixel = 0
        RGB.Position = UDim2.new(0.0670000017, 0, 0.0680000037, 0)
        RGB.Size = UDim2.new(0, 179, 0, 161)
        RGB.AutoButtonColor = false
        RGB.Image = "rbxassetid://6523286724"
        RGB.ZIndex = 16

        RGBCircle.Name = "RGBCircle"
        RGBCircle.Parent = RGB
        RGBCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        RGBCircle.BackgroundTransparency = 1.000
        RGBCircle.BorderColor3 = Color3.fromRGB(27, 42, 53)
        RGBCircle.BorderSizePixel = 0
        RGBCircle.Size = UDim2.new(0, 14, 0, 14)
        RGBCircle.Image = "rbxassetid://3926309567"
        RGBCircle.ImageRectOffset = Vector2.new(628, 420)
        RGBCircle.ImageRectSize = Vector2.new(48, 48)
        RGBCircle.ZIndex = 16

        Darkness.Name = "Darkness"
        Darkness.Parent = colorpickerFrame
        Darkness.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Darkness.BorderSizePixel = 0
        Darkness.Position = UDim2.new(0.831940293, 0, 0.0680000708, 0)
        Darkness.Size = UDim2.new(0, 33, 0, 161)
        Darkness.AutoButtonColor = false
        Darkness.Image = "rbxassetid://156579757"
        Darkness.ZIndex = 16

        DarknessCircle.Name = "DarknessCircle"
        DarknessCircle.Parent = Darkness
        DarknessCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        DarknessCircle.BorderSizePixel = 0
        DarknessCircle.Position = UDim2.new(0, 0, 0, 0)
        DarknessCircle.Size = UDim2.new(0, 33, 0, 5)
        DarknessCircle.ZIndex = 16

        colorHex.Name = "colorHex"
        colorHex.Parent = colorpickerFrame
        colorHex.BackgroundColor3 = Color3.fromRGB(9, 8, 13)
        colorHex.Position = UDim2.new(0.0717131495, 0, 0.850678742, 0)
        colorHex.Size = UDim2.new(0, 94, 0, 24)
        colorHex.Font = Enum.Font.GothamSemibold
        colorHex.Text = "#FFFFFF"
        colorHex.TextColor3 = Color3.fromRGB(234, 239, 245)
        colorHex.TextSize = 14.000
        colorHex.ZIndex = 16

        Copy.Parent = colorpickerFrame
        Copy.BackgroundColor3 = Color3.fromRGB(9, 8, 13)
        Copy.Position = UDim2.new(0.72111553, 0, 0.850678742, 0)
        Copy.Size = UDim2.new(0, 60, 0, 24)
        Copy.AutoButtonColor = false
        Copy.Font = Enum.Font.GothamSemibold
        Copy.Text = "Copy"
        Copy.TextColor3 = Color3.fromRGB(234, 239, 245)
        Copy.TextSize = 14.000
        Copy.ZIndex = 16
        Copy.MouseButton1Click:Connect(function()
            if setclipboard then
                setclipboard(tostring(colorHex.Text))
                Library:Notify("Cryptweb:", tostring(colorHex.Text))
                Library:Notify("Cryptweb:", "Done!")
            else
                print(tostring(colorHex.Text))
                Library:Notify("Cryptweb:", tostring(colorHex.Text))
                Library:Notify("Cryptweb:", "Your exploit does not support the function 'setclipboard', so we've printed it out.")
            end
        end)

        local ceil, clamp, atan2, pi = math.ceil, math.clamp, math.atan2, math.pi
        local tostr, sub = tostring, string.sub
        local fromHSV = Color3.fromHSV
        local v2, udim2 = Vector2.new, UDim2.new

        local UserInputService = game:GetService("UserInputService")
        local getmouse = game.Players.LocalPlayer:GetMouse()

        local WheelDown = false
        local SlideDown = false

        local function toPolar(v)
            return atan2(v.y, v.x), v.magnitude
        end

        local function radToDeg(x)
            return ((x + pi) / (2 * pi)) * 360
        end
        local hue, saturation, value = 0, 0, 1
        local color = {1,1,1}

        local function to_hex(color)
            return string.format("#%02X%02X%02X", color.R * 255, color.G * 255, color.B * 255)
        end
        local function update()
            local r = color[1]
            local g = color[2]
            local b = color[3]

            local c = fromHSV(r, g, b)
            colorHex.Text = tostring(to_hex(c))
        end
        local function mouseLocation()
            return game.Players.LocalPlayer:GetMouse()
        end
        local function UpdateSlide(iX,iY)   
            local ml = mouseLocation()
            local y = ml.Y - Darkness.AbsolutePosition.Y
            local maxY = Darkness.AbsoluteSize.Y
            if y<0 then y=0 end
            if y>maxY then y=maxY end
            y = y/maxY
            local cy = DarknessCircle.AbsoluteSize.Y/2
            color = {color[1],color[2],1-y}
            local realcolor = Color3.fromHSV(color[1],color[2],color[3])
            DarknessCircle.BackgroundColor3 = realcolor
            DarknessCircle.Position = UDim2.new(0,0,y,-cy)
            options.callback(realcolor)

            update()
        end
        local function UpdateRing(iX,iY)
            local ml = mouseLocation()
            local x,y = ml.X - RGB.AbsolutePosition.X,ml.Y - RGB.AbsolutePosition.Y
            local maxX,maxY = RGB.AbsoluteSize.X,RGB.AbsoluteSize.Y
            if x<0 then 
                x=0 
            end
            if x>maxX then 
                x=maxX 
            end
            if y<0 then 
                y=0 
            end
            if y>maxY then 
                y=maxY
            end
            x = x/maxX
            y = y/maxY

            local cx = RGBCircle.AbsoluteSize.X/2
            local cy = RGBCircle.AbsoluteSize.Y/2

            RGBCircle.Position = udim2(x,-cx,y,-cy)

            color = {1-x,1-y,color[3]}
            local realcolor = Color3.fromHSV(color[1],color[2],color[3])
            Darkness.BackgroundColor3 = realcolor
            DarknessCircle.BackgroundColor3 = realcolor
            options.callback(realcolor)
            update()
        end


        RGB.MouseButton1Down:Connect(function()
            WheelDown = true
            UpdateRing(getmouse.X,getmouse.Y)
        end)
        Darkness.MouseButton1Down:Connect(function()
            SlideDown = true
            UpdateSlide(getmouse.X,getmouse.Y)
        end)


        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                WheelDown = false
                SlideDown = false
            end
        end)

        RGB.MouseMoved:Connect(function()
            if WheelDown then
                UpdateRing(getmouse.X,getmouse.Y)
            end
        end)
        Darkness.MouseMoved:Connect(function()
            if SlideDown then
                UpdateSlide(getmouse.X,getmouse.Y)
            end
        end)

        local function setcolor(tbl)
            local realcolor = Color3.fromHSV(tbl[1],tbl[2],tbl[3])
            colorHex.Text = tostring(to_hex(realcolor))
            DarknessCircle.BackgroundColor3 = realcolor
        end
        setcolor({hue,sat,val})
    end

    function elements:Keybind(options)
        if not options.text or not options.default or not options.callback then
            Library:Notify("Keybind Error", "Missing arguments!")
            return
        end

        local blacklisted = {
            Return = true,
            Space = true,
            Tab = true,
            W = true,
            A = true,
            S = true,
            D = true,
            I = true,
            O = true,
            Unknown = true
        }

        local short = {
            RightControl = "RCtrl",
            LeftControl = "LCtrl",
            LeftShift = "LShift",
            RightShift = "RShift",
            MouseButton1 = "M1",
            MouseButton2 = "M2",
            LeftAlt = "LAlt",
            RightAlt = "RAlt"
        }

        local oldKey = options.default.Name
        local Keybind = Instance.new("Frame")
        local keybindButton = Instance.new("TextButton")
        local keybindLabel = Instance.new("TextLabel")

        Keybind.Name = "Keybind"
        Keybind.Parent = sectionFrame
        Keybind.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Keybind.BackgroundTransparency = 1.000
        Keybind.BorderSizePixel = 0
        Keybind.Position = UDim2.new(0.0348837227, 0, 0.945454538, 0)
        Keybind.Size = UDim2.new(0, 200, 0, 22)
        Keybind.ZIndex = 2
        buttoneffect({frame = keybindButton, entered = Keybind})

        keybindButton.Name = "keybindButton"
        keybindButton.Parent = Keybind
        keybindButton.AnchorPoint = Vector2.new(0.5, 0.5)
        keybindButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        keybindButton.BackgroundTransparency = 1.000
        keybindButton.BorderSizePixel = 0
        keybindButton.Position = UDim2.new(0.5, 0, 0.5, 0)
        keybindButton.Size = UDim2.new(0, 200, 0, 22)
        keybindButton.AutoButtonColor = false
        keybindButton.Font = Enum.Font.Gotham
        keybindButton.Text = " " .. options.text
        keybindButton.TextColor3 = Color3.fromRGB(157, 171, 182)
        keybindButton.TextSize = 14.000
        keybindButton.TextXAlignment = Enum.TextXAlignment.Left
        keybindButton.MouseButton1Click:Connect(function()
            keybindLabel.Text = "... "
            TweenService:Create(keybindButton, TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                TextColor3 = Color3.fromRGB(234, 239, 246)
            }):Play()
            TweenService:Create(keybindLabel, TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                TextColor3 = Color3.fromRGB(234, 239, 246)
            }):Play()
            local inputbegan = game:GetService("UserInputService").InputBegan:wait()
            if not blacklisted[inputbegan.KeyCode.Name] then
                TweenService:Create(keybindLabel, TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    TextColor3 = Color3.fromRGB(157, 171, 182)
                }):Play()
                TweenService:Create(keybindButton, TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    TextColor3 = Color3.fromRGB(157, 171, 182)
                }):Play()
                keybindLabel.Text = short[inputbegan.KeyCode.Name] or inputbegan.KeyCode.Name
                oldKey = inputbegan.KeyCode.Name
            else
                TweenService:Create(keybindButton, TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    TextColor3 = Color3.fromRGB(157, 171, 182)
                }):Play()
                TweenService:Create(keybindLabel, TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    TextColor3 = Color3.fromRGB(157, 171, 182)
                }):Play()
                keybindLabel.Text = short[oldKey] or oldKey
            end
        end)

        game:GetService("UserInputService").InputBegan:Connect(function(key, focused)
            if not focused then
                if key.KeyCode.Name == oldKey then
                    options.callback(oldKey)
                end
            end
        end)

        keybindLabel.Name = "keybindLabel"
        keybindLabel.Parent = keybindButton
        keybindLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        keybindLabel.BackgroundColor3 = Color3.fromRGB(157, 171, 182)
        keybindLabel.BackgroundTransparency = 1.000
        keybindLabel.Position = UDim2.new(0.910000026, 0, 0.5, 0)
        keybindLabel.Size = UDim2.new(0, 36, 0, 22)
        keybindLabel.Font = Enum.Font.Gotham
        keybindLabel.Text = oldKey .. " "
        keybindLabel.TextColor3 = Color3.fromRGB(157, 171, 182)
        keybindLabel.TextSize = 14.000
        keybindLabel.TextXAlignment = Enum.TextXAlignment.Right
    end

    elements[elementType](elements, options)
end

return Library
