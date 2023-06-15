--MD3Config stores all tables, defaults, definitions, paths, etc, and is also responsible for iterating over the defaults table and making assignments to any serialized data on load
--define the player data global state
MD3PlayerData = {};
MD3Config = {};
self = MD3Config;

self.MD3ClassColors = RAID_CLASS_COLORS;
self.MD3PowerColors = PowerBarColor;
self.MD3Environment = "dev";

--user interaction config
self.MD3UserInteraction = {
	DefaultMoveButton = "LeftButton",
	DefaultMoveFunction = IsShiftKeyDown,
	LockedMoveFunction = function() return false end;
};

self.MD3FilePathConfig = {
	rootPath = "Interface\\Addons\\MistrasDiabloOrbs",
	orbMasksPath = "Interface\\Addons\\MistrasDiabloOrbs\\assets\\Masks\\256",
	orbFillsPath = "Interface\\Addons\\MistrasDiabloOrbs\\assets\\Fills\\256",
	orbAnimationsPath = "Interface\\Addons\\MistrasDiabloOrbs\\assets\\Animations\\256",
	orbContainersPath = "Interface\\Addons\\MistrasDiabloOrbs\\assets\\Containers\\256",
	orbDecorationsPath = "Interface\\Addons\\MistrasDiabloOrbs\\assets\\Decorations\\512",
	fonts = "Interface\\Addons\\MistrasDiabloOrbs\\assets\\fonts"
};

self.MD3LabelTypes = {
	Percentage = 0,
	CommaSeparated = 1,
	Truncated = 2,
	Raw = 3,
};

self.MD3Fonts = {
	["benegraphic"] = {
		filePath = self.MD3FilePathConfig.fonts.."\\Benegraphic.ttf",
		friendlyName = "Benegraphic",
		description = ""
	},
	["crashLike"] = {
		filePath =self.MD3FilePathConfig.fonts.."\\crash-a-like.ttf",
		friendlyName = "Crash-a-Like",
		description = ""
	},
	["immortal"] = {
		filePath =self.MD3FilePathConfig.fonts.."\\IMMORTAL.ttf",
		friendlyName = "Immortal",
		description = ""
	},
	["wwings"] = {
		filePath =self.MD3FilePathConfig.fonts.."\\Of Wildflowers and Wings.ttf",
		friendlyName = "Of Wildflowers and Wings",
		description = ""
	},
	["oj2"] = {
		filePath =self.MD3FilePathConfig.fonts.."\\orange juice 2.0.ttf",
		friendlyName = "Orange Juice 2.0",
		description = ""
	},
	["smileocean"] = {
		filePath =self.MD3FilePathConfig.fonts.."\\Smile of the Ocean.ttf",
		friendlyName = "Smile of the Ocean",
		description = ""
	}
};

self.MD3Textures = {
	masks = {
		["whole"] = {
				height = 256,
				width = 256,
				clampTypeX = "CLAMPTOBLACKADDITIVE",
				clampTypeY = "CLAMPTOBLACKADDITIVE",
				attachPoint = "BOTTOM",
				offsetX = 0,
				offsetY = 0,
				filePath = self.MD3FilePathConfig.orbMasksPath .. "\\whole_anim_mask.tga"
		},
		["halves"] = {
			["left"] = {
				height = 256,
				width = 128,
				clampTypeX = "CLAMPTOBLACKADDITIVE",
				clampTypeY = "CLAMPTOBLACKADDITIVE",
				attachPoint = "BOTTOMLEFT",
				offsetX = 0,
				offsetY = 0,
				filePath = self.MD3FilePathConfig.orbMasksPath .. "\\half_anim_left_mask.tga"
			},
			["right"] = {
				height = 256,
				width = 128,
				clampTypeX = "CLAMPTOBLACKADDITIVE",
				clampTypeY = "CLAMPTOBLACKADDITIVE",
				attachPoint = "BOTTOMRIGHT",
				offsetX = 0,
				offsetY = 0,
				filePath = self.MD3FilePathConfig.orbMasksPath .. "\\half_anim_right_mask.tga"
			}
		}
	},
	fillAnimations = {
		["whole"] = {
			["Ripples"] = {
				size = 256,
				textureKey = "Ripples",
				filePath = self.MD3FilePathConfig.orbAnimationsPath .. "\\fluid_1_anim.tga"
			},
			["Bubbles"] = {
				size = 256,
				textureKey = "Bubbles",
				filePath = self.MD3FilePathConfig.orbAnimationsPath .. "\\fluid_2_anim.tga"
			},
			["Distortion"] = {
				size = 256,
				textureKey = "Bubbles",
				filePath = self.MD3FilePathConfig.orbAnimationsPath .. "\\fluid_3_anim.tga"
			}
		}
	},
	fills = {
		["whole"] = {
			["Ripples"] = {
				size = 256,
				textureKey = "Ripples",
				filePath = self.MD3FilePathConfig.orbFillsPath .. "\\fluid_1_whole.tga"
			},
			["Bubbles"] = {
				size = 256,
				textureKey = "Bubbles",
				filePath = self.MD3FilePathConfig.orbFillsPath .. "\\fluid_2_whole.tga"
			},
			["Distortion"] = {
				size = 256,
				textureKey = "Distortion",
				filePath = self.MD3FilePathConfig.orbFillsPath .. "\\fluid_3_whole.tga"
			}
		},
		["halves"] = {
			["left"] = {
				["Ripples"] = {
					size = 256,
					textureKey = "Ripples",
					filePath = self.MD3FilePathConfig.orbFillsPath .. "\\fluid_1_half_left.tga"
				},
				["Bubbles"] = {
					size = 256,
					textureKey = "Bubbles",
					filePath = self.MD3FilePathConfig.orbFillsPath .. "\\fluid_2_half_left.tga"
				},
				["Distortion"] = {
					size = 256,
					textureKey = "Distortion",
					filePath = self.MD3FilePathConfig.orbFillsPath .. "\\fluid_3_half_left.tga"
				},
			},
			["right"] = {
				["Ripples"] = {
					size = 256,
					textureKey = "Ripples",
					filePath = self.MD3FilePathConfig.orbFillsPath .. "\\fluid_1_half_right.tga"
				},
				["Bubbles"] = {
					size = 256,
					textureKey = "Bubbles",
					filePath = self.MD3FilePathConfig.orbFillsPath .. "\\fluid_2_half_right.tga"
				},
				["Distortion"] = {
					size = 256,
					textureKey = "Distortion",
					filePath = self.MD3FilePathConfig.orbFillsPath .. "\\fluid_3_half_right.tga"
				}
			}
		}
	},
	containers = {
		["whole"] = {
			["WholeGlass"] = {
				size = 258,
				filePath = self.MD3FilePathConfig.orbContainersPath .. "\\full_glass.tga"
			},
		},
		["halves"] = {
			["SplitGlass"] = {
				size = 258,
				filePath = self.MD3FilePathConfig.orbContainersPath .. "\\split_glass.tga"
			}
		}
	},
	decorations = {
		["Cracked"] = {
			size = 512,
			filePath = self.MD3FilePathConfig.orbDecorationsPath .. "\\cracked.tga"
		},
		["TwinCracked"] = {
			size = 512,
			filePath = self.MD3FilePathConfig.orbDecorationsPath .. "\\twin_cracked.tga"
		}
	}
};

self.MD3PlayerDefaults = {
	orbs = {
		[1] = {
			name = "Orb-1",
			fillType = "single",
			unit = "player",
			containerData = self.MD3Textures.containers.whole.WholeGlass,
			scale = .7,
			activeProfile = "default",
			isPositionLocked = true,
			profileNames = {
				[1] = "default"
			},
			fills = {
				[1] = {
					renderLayer = "BACKGROUND",
					fillData = self.MD3Textures.fills.whole.Distortion,
					textureKey = "Distortion",
					resourceType = "health",
					blendMode = "BLEND",
					maskData = self.MD3Textures.masks.whole,
					designation = "whole",
					colorProfiles = {
						["default"] = {
							triggers = {
								["Default"] = {
									color = {
										r = .7,
										g = .41,
										b = .45,
										a = 1
									}
								},
								["CombatStatusChanged"] = {
									color = {
										r = 1,
										g = 0,
										b = 1,
										a = 1
									}
								},
								["SpecializationChanged"] = {
									["Vengeance"] = {
										color = {
											r = .25,
											g = 1,
											b = .7,
											a = 1
										}
									}
								}
							}
						}
					},
					animationTextures = {
						[1] = {
							animationData = self.MD3Textures.fillAnimations.whole.Distortion,
							textureKey = "Distortion",
							renderLayer = "BORDER",
							blendMode = "ADD",
							colorProfiles = {
								["default"] = {
									triggers = {
										["Default"] = {
											color = {
												r = .7,
												g = .41,
												b = .45,
												a = 1
											}
										}
									}
								}
							},
							animation = {
								animationDuration = 30,
								degreeMultiplier = -1,
								animationType = "Rotation"
							}
						},
						[2] = {
							animationData = self.MD3Textures.fillAnimations.whole.Distortion,
							textureKey = "Distortion",
							renderLayer = "BORDER",
							blendMode = "ADD",
							colorProfiles = {
								["default"] = {
									triggers = {
										["Default"] = {
											color = {
												r = .7,
												g = .41,
												b = .45,
												a = 1
											}
										}
									}
								}
							},
							animation = {
								animationDuration = 25,
								degreeMultiplier = 1,
								animationType = "Rotation"
							}
						}
					},
					valueLabels = {
						[1] = {
							fontData = self.MD3Fonts.immortal,
							fontSize = 50,
							labelType = self.MD3LabelTypes.Truncated,
							offsets = {x = 0, y = 35},
							outlineType = "THINOUTLINE",
							renderLayer = "OVERLAY",
							prefix = "",
							postfix = "",
							hideWhenZero = false,
							colorProfiles = {
								["default"] = {
									triggers = {
										["Default"] = {
											color = {
												r = .7,
												g = .41,
												b = .45,
												a = 1
											}
										}
									}
								}
							}
						}
					}
				},
				[2] = {
					renderLayer = "BACKGROUND",
					fillData = self.MD3Textures.fills.whole.Distortion,
					textureKey = "Distortion",
					resourceType = "absorbs",
					blendMode = "BLEND",
					maskData = self.MD3Textures.masks.whole,
					designation = "whole",
					colorProfiles = {
						["default"] = {
							triggers = {
								["Default"] = {
									color = {
										r = .7,
										g = .41,
										b = .45,
										a = 1
									}
								}
							}
						}
					},
					animationTextures = {
						[1] = {
							animationData = self.MD3Textures.fillAnimations.whole.Distortion,
							textureKey = "Distortion",
							renderLayer = "BORDER",
							blendMode = "ADD",
							colorProfiles = {
								["default"] = {
									triggers = {
										["Default"] = {
											color = {
												r = .7,
												g = .41,
												b = .45,
												a = 1
											}
										}
									}
								}
							},
							animation = {
								animationDuration = 30,
								degreeMultiplier = -1,
								animationType = "Rotation"
							}
						},
						[2] = {
							animationData = self.MD3Textures.fillAnimations.whole.Distortion,
							textureKey = "Distortion",
							renderLayer = "BORDER",
							blendMode = "ADD",
							colorProfiles = {
								["default"] = {
									triggers = {
										["Default"] = {
											color = {
												r = .7,
												g = .41,
												b = .45,
												a = 1
											}
										}
									}
								}
							},
							animation = {
								animationDuration = 25,
								degreeMultiplier = 1,
								animationType = "Rotation"
							}
						}
					},
					valueLabels = {
						[1] = {
							fontData = self.MD3Fonts.crashLike,
							fontSize = 44,
							labelType = self.MD3LabelTypes.Truncated,
							offsets = {x = 0, y = -15},
							outlineType = "THINOUTLINE",
							renderLayer = "OVERLAY",
							prefix = "(",
							postfix = ")",
							hideWhenZero = true,
							colorProfiles = {
								["default"] = {
									triggers = {
										["Default"] = {
											color = {
												r = .7,
												g = .41,
												b = .45,
												a = 1
											}
										}
									}
								}
							}
						}
					}
				}
			}
		},
		[2] = {
			name = "Orb-2",
			fillType = "double",
			unit = "player",
			containerData = self.MD3Textures.containers.halves.SplitGlass,
			scale = .7,
			activeProfile = "default",
			profileNames = {
				[1] = "default"
			},
			fills = {
				[1] = {
					renderLayer = "BACKGROUND",
					fillData = self.MD3Textures.fills.halves.left.Ripples,
					textureKey = "Ripples",
					resourceType = "health",
					blendMode = "BLEND",
					maskData = self.MD3Textures.masks.halves.left,
					designation = "left",
					colorProfiles = {
						["default"] = {
							triggers = {
								["Default"] = {
									color = {
										r = .7,
										g = .41,
										b = .45,
										a = 1
									}
								}
							}
						}
					},
					animationTextures = {
						[1] = {
							animationData = self.MD3Textures.fillAnimations.whole.Ripples,
							textureKey = "Ripples",
							renderLayer = "BORDER",
							blendMode = "ADD",
							colorProfiles = {
								["default"] = {
									triggers = {
										["Default"] = {
											color = {
												r = .7,
												g = .41,
												b = .45,
												a = 1
											}
										}
									}
								}
							},
							animation = {
								animationDuration = 30,
								degreeMultiplier = -1,
								animationType = "Rotation"
							}
						},
						[2] = {
							animationData = self.MD3Textures.fillAnimations.whole.Ripples,
							textureKey = "Ripples",
							renderLayer = "BORDER",
							blendMode = "ADD",
							colorProfiles = {
								["default"] = {
									triggers = {
										["Default"] = {
											color = {
												r = .7,
												g = .41,
												b = .45,
												a = 1
											}
										}
									}
								}
							},
							animation = {
								animationDuration = 25,
								degreeMultiplier = 1,
								animationType = "Rotation"
							}
						}
					}
				},
				[2] = {
					renderLayer = "BACKGROUND",
					fillData = self.MD3Textures.fills.halves.right.Distortion,
					textureKey = "Distortion",
					resourceType = "defaultPower",
					blendMode = "BLEND",
					maskData = self.MD3Textures.masks.halves.right,
					designation = "right",
					colorProfiles = {
						["default"] = {
							triggers = {
								["Default"] = {
									color = {
										r = .7,
										g = .41,
										b = .45,
										a = 1
									}
								}
							}
						}
					},
					animationTextures = {
						[1] = {
							animationData = self.MD3Textures.fillAnimations.whole.Distortion,
							textureKey = "Distortion",
							renderLayer = "BORDER",
							blendMode = "ADD",
							colorProfiles = {
								["default"] = {
									triggers = {
										["Default"] = {
											color = {
												r = .7,
												g = .41,
												b = .45,
												a = 1
											}
										}
									}
								}
							},
							animation = {
								animationDuration = 30,
								degreeMultiplier = -1,
								animationType = "Rotation"
							}
						},
						[2] = {
							animationData = self.MD3Textures.fillAnimations.whole.Distortion,
							textureKey = "Distortion",
							renderLayer = "BORDER",
							blendMode = "ADD",
							colorProfiles = {
								["default"] = {
									triggers = {
										["Default"] = {
											color = {
												r = .7,
												g = .41,
												b = .45,
												a = 1
											}
										}
									}
								}
							},
							animation = {
								animationDuration = 25,
								degreeMultiplier = 1,
								animationType = "Rotation"
							}
						}
					}
				},
				[3] = {
					renderLayer = "BACKGROUND",
					fillData = self.MD3Textures.fills.halves.left.Ripples,
					textureKey = "Ripples",
					resourceType = "absorbs",
					blendMode = "BLEND",
					maskData = self.MD3Textures.masks.halves.left,
					designation = "left",
					colorProfiles = {
						["default"] = {
							triggers = {
								["Default"] = {
									color = {
										r = .7,
										g = .41,
										b = .45,
										a = 1
									}
								}
							}
						}
					},
					animationTextures = {
						[1] = {
							animationData = self.MD3Textures.fillAnimations.whole.Ripples,
							textureKey = "Ripples",
							renderLayer = "BORDER",
							blendMode = "ADD",
							colorProfiles = {
								["default"] = {
									triggers = {
										["Default"] = {
											color = {
												r = .7,
												g = .41,
												b = .45,
												a = 1
											}
										}
									}
								}
							},
							animation = {
								animationDuration = 30,
								degreeMultiplier = -1,
								animationType = "Rotation"
							}
						},
						[2] = {
							animationData = self.MD3Textures.fillAnimations.whole.Ripples,
							textureKey = "Ripples",
							renderLayer = "BORDER",
							blendMode = "ADD",
							colorProfiles = {
								["default"] = {
									triggers = {
										["Default"] = {
											color = {
												r = .7,
												g = .41,
												b = .45,
												a = 1
											}
										}
									}
								}
							},
							animation = {
								animationDuration = 25,
								degreeMultiplier = 1,
								animationType = "Rotation"
							}
						}
					}
				}
			}
		},
		[3] = {
			name = "Orb-3",
			fillType = "double",
			unit = "target",
			containerData = self.MD3Textures.containers.halves.SplitGlass,
			scale = .5,
			activeProfile = "default",
			profileNames = {
				[1] = "default"
			},
			fills = {
				[1] = {
					renderLayer = "BACKGROUND",
					fillData = self.MD3Textures.fills.halves.left.Ripples,
					textureKey = "Ripples",
					resourceType = "health",
					blendMode = "BLEND",
					maskData = self.MD3Textures.masks.halves.left,
					designation = "left",
					colorProfiles = {
						["default"] = {
							triggers = {
								["Default"] = {
									color = {
										r = .7,
										g = .41,
										b = .45,
										a = 1
									}
								}
							}
						}
					},
					animationTextures = {
						[1] = {
							animationData = self.MD3Textures.fillAnimations.whole.Ripples,
							textureKey = "Ripples",
							renderLayer = "BORDER",
							blendMode = "ADD",
							colorProfiles = {
								["default"] = {
									triggers = {
										["Default"] = {
											color = {
												r = .7,
												g = .41,
												b = .45,
												a = 1
											}
										}
									}
								}
							},
							animation = {
								animationDuration = 30,
								degreeMultiplier = -1,
								animationType = "Rotation"
							}
						},
						[2] = {
							animationData = self.MD3Textures.fillAnimations.whole.Ripples,
							textureKey = "Ripples",
							renderLayer = "BORDER",
							blendMode = "ADD",
							colorProfiles = {
								["default"] = {
									triggers = {
										["Default"] = {
											color = {
												r = .7,
												g = .41,
												b = .45,
												a = 1
											}
										}
									}
								}
							},
							animation = {
								animationDuration = 25,
								degreeMultiplier = 1,
								animationType = "Rotation"
							}
						}
					}
				},
				[2] = {
					renderLayer = "BACKGROUND",
					fillData = self.MD3Textures.fills.halves.right.Distortion,
					textureKey = "Distortion",
					resourceType = "defaultPower",
					blendMode = "BLEND",
					maskData = self.MD3Textures.masks.halves.right,
					designation = "right",
					colorProfiles = {
						["default"] = {
							triggers = {
								["Default"] = {
									color = {
										r = .7,
										g = .41,
										b = .45,
										a = 1
									}
								}
							}
						}
					},
					animationTextures = {
						[1] = {
							animationData = self.MD3Textures.fillAnimations.whole.Distortion,
							textureKey = "Distortion",
							renderLayer = "BORDER",
							blendMode = "ADD",
							colorProfiles = {
								["default"] = {
									triggers = {
										["Default"] = {
											color = {
												r = .7,
												g = .41,
												b = .45,
												a = 1
											}
										}
									}
								}
							},
							animation = {
								animationDuration = 30,
								degreeMultiplier = -1,
								animationType = "Rotation"
							}
						},
						[2] = {
							animationData = self.MD3Textures.fillAnimations.whole.Distortion,
							textureKey = "Distortion",
							renderLayer = "BORDER",
							blendMode = "ADD",
							colorProfiles = {
								["default"] = {
									triggers = {
										["Default"] = {
											color = {
												r = .7,
												g = .41,
												b = .45,
												a = 1
											}
										}
									}
								}
							},
							animation = {
								animationDuration = 25,
								degreeMultiplier = 1,
								animationType = "Rotation"
							}
						}
					}
				},
				[3] = {
					renderLayer = "BACKGROUND",
					fillData = self.MD3Textures.fills.halves.left.Ripples,
					textureKey = "Ripples",
					resourceType = "absorbs",
					blendMode = "BLEND",
					maskData = self.MD3Textures.masks.halves.left,
					designation = "left",
					colorProfiles = {
						["default"] = {
							triggers = {
								["Default"] = {
									color = {
										r = .7,
										g = .41,
										b = .45,
										a = 1
									}
								}
							}
						}
					},
					animationTextures = {
						[1] = {
							animationData = self.MD3Textures.fillAnimations.whole.Ripples,
							textureKey = "Ripples",
							renderLayer = "BORDER",
							blendMode = "ADD",
							colorProfiles = {
								["default"] = {
									triggers = {
										["Default"] = {
											color = {
												r = .7,
												g = .41,
												b = .45,
												a = 1
											}
										}
									}
								}
							},
							animation = {
								animationDuration = 30,
								degreeMultiplier = -1,
								animationType = "Rotation"
							}
						},
						[2] = {
							animationData = self.MD3Textures.fillAnimations.whole.Ripples,
							textureKey = "Ripples",
							renderLayer = "BORDER",
							blendMode = "ADD",
							colorProfiles = {
								["default"] = {
									triggers = {
										["Default"] = {
											color = {
												r = .7,
												g = .41,
												b = .45,
												a = 1
											}
										}
									}
								}
							},
							animation = {
								animationDuration = 25,
								degreeMultiplier = 1,
								animationType = "Rotation"
							}
						}
					}
				}
			}
		},
		[4] = {
			name = "Orb-4",
			fillType = "double",
			unit = "targettarget",
			containerData = self.MD3Textures.containers.halves.SplitGlass,
			scale = .35,
			activeProfile = "default",
			profileNames = {
				[1] = "default"
			},
			fills = {
				[1] = {
					renderLayer = "BACKGROUND",
					fillData = self.MD3Textures.fills.halves.left.Ripples,
					textureKey = "Ripples",
					resourceType = "health",
					blendMode = "BLEND",
					maskData = self.MD3Textures.masks.halves.left,
					designation = "left",
					colorProfiles = {
						["default"] = {
							triggers = {
								["Default"] = {
									color = {
										r = .7,
										g = .41,
										b = .45,
										a = 1
									}
								}
							}
						}
					},
					animationTextures = {
						[1] = {
							animationData = self.MD3Textures.fillAnimations.whole.Ripples,
							textureKey = "Ripples",
							renderLayer = "BORDER",
							blendMode = "ADD",
							colorProfiles = {
								["default"] = {
									triggers = {
										["Default"] = {
											color = {
												r = .7,
												g = .41,
												b = .45,
												a = 1
											}
										}
									}
								}
							},
							animation = {
								animationDuration = 30,
								degreeMultiplier = -1,
								animationType = "Rotation"
							}
						},
						[2] = {
							animationData = self.MD3Textures.fillAnimations.whole.Ripples,
							textureKey = "Ripples",
							renderLayer = "BORDER",
							blendMode = "ADD",
							colorProfiles = {
								["default"] = {
									triggers = {
										["Default"] = {
											color = {
												r = .7,
												g = .41,
												b = .45,
												a = 1
											}
										}
									}
								}
							},
							animation = {
								animationDuration = 25,
								degreeMultiplier = 1,
								animationType = "Rotation"
							}
						}
					}
				},
				[2] = {
					renderLayer = "BACKGROUND",
					fillData = self.MD3Textures.fills.halves.right.Distortion,
					textureKey = "Distortion",
					resourceType = "defaultPower",
					blendMode = "BLEND",
					maskData = self.MD3Textures.masks.halves.right,
					designation = "right",
					colorProfiles = {
						["default"] = {
							triggers = {
								["Default"] = {
									color = {
										r = .7,
										g = .41,
										b = .45,
										a = 1
									}
								}
							}
						}
					},
					animationTextures = {
						[1] = {
							animationData = self.MD3Textures.fillAnimations.whole.Distortion,
							textureKey = "Distortion",
							renderLayer = "BORDER",
							blendMode = "ADD",
							colorProfiles = {
								["default"] = {
									triggers = {
										["Default"] = {
											color = {
												r = .7,
												g = .41,
												b = .45,
												a = 1
											}
										}
									}
								}
							},
							animation = {
								animationDuration = 30,
								degreeMultiplier = -1,
								animationType = "Rotation"
							}
						},
						[2] = {
							animationData = self.MD3Textures.fillAnimations.whole.Distortion,
							textureKey = "Distortion",
							renderLayer = "BORDER",
							blendMode = "ADD",
							colorProfiles = {
								["default"] = {
									triggers = {
										["Default"] = {
											color = {
												r = .7,
												g = .41,
												b = .45,
												a = 1
											}
										}
									}
								}
							},
							animation = {
								animationDuration = 25,
								degreeMultiplier = 1,
								animationType = "Rotation"
							}
						}
					}
				},
				[3] = {
					renderLayer = "BACKGROUND",
					fillData = self.MD3Textures.fills.halves.left.Ripples,
					textureKey = "Ripples",
					resourceType = "absorbs",
					blendMode = "BLEND",
					maskData = self.MD3Textures.masks.halves.left,
					designation = "left",
					colorProfiles = {
						["default"] = {
							triggers = {
								["Default"] = {
									color = {
										r = .7,
										g = .41,
										b = .45,
										a = 1
									}
								}
							}
						}
					},
					animationTextures = {
						[1] = {
							animationData = self.MD3Textures.fillAnimations.whole.Ripples,
							textureKey = "Ripples",
							renderLayer = "BORDER",
							blendMode = "ADD",
							colorProfiles = {
								["default"] = {
									triggers = {
										["Default"] = {
											color = {
												r = .7,
												g = .41,
												b = .45,
												a = 1
											}
										}
									}
								}
							},
							animation = {
								animationDuration = 30,
								degreeMultiplier = -1,
								animationType = "Rotation"
							}
						},
						[2] = {
							animationData = self.MD3Textures.fillAnimations.whole.Ripples,
							textureKey = "Ripples",
							renderLayer = "BORDER",
							blendMode = "ADD",
							colorProfiles = {
								["default"] = {
									triggers = {
										["Default"] = {
											color = {
												r = .7,
												g = .41,
												b = .45,
												a = 1
											}
										}
									}
								}
							},
							animation = {
								animationDuration = 25,
								degreeMultiplier = 1,
								animationType = "Rotation"
							}
						}
					}
				}
			}
		}
	}
};

function self:SetMissingDefaultsInPlayerDataTable()
	MD3Utils:RecursiveIterateCompareAndAssignTableData(self.MD3PlayerDefaults, MD3PlayerData);
end