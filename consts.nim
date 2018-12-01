const screenSize* = (1024, 768)

when defined(macosx):
  const globalScale* = 1.5
else:
  const globalScale* = 1.0