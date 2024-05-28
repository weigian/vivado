import pyautogui

# https://pyautogui.readthedocs.io/en/latest
# https://silaoa.github.io/2020/2020-11-27-Python%E8%87%AA%E5%8A%A8%E6%93%8D%E4%BD%9CGUI%E7%A5%9E%E5%99%A8PyAutoGUI.html

# open example project
pyautogui.click(2459, y=513)
# next
pyautogui.click(2900, y=820, duration=1)
# base microblaze
pyautogui.click(2481, y=342, duration=1)
# next
pyautogui.click(2900, y=820, duration=1)
# next
pyautogui.click(2900, y=820, duration=1)
# next
pyautogui.click(2900, y=820)
# finish
pyautogui.click(3007, y=820)
